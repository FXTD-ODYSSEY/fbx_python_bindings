# -*- coding: utf-8 -*-
"""
Build fbx.pyd
Use specified python version to build pyd.
"""

from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

__author__ = "timmyliang"
__email__ = "820472580@qq.com"
__date__ = "2023-04-22 11:21:48"


import os
import sys
import glob
import shutil
import zipfile
import fnmatch
import tempfile
import logging
import subprocess

try:
    from urllib.request import Request, urlopen  # Python 3
except ImportError:
    from urllib2 import Request, urlopen  # Python 2

try:
    from pathlib import Path
except ImportError:
    # NOTES(timmyliang): mimic pathlib in python2
    class Path(str):
        @property
        def parent(self):
            return Path(os.path.dirname(self))

        @property
        def name(self):
            return Path(os.path.basename(self))

        def glob(self, pattern):
            for path in glob.glob(os.path.join(self, pattern)):
                yield Path(path)

        def rglob(self, pattern):
            for dirpath, dirnames, filenames in os.walk(self):
                for filename in fnmatch.filter(filenames, pattern):
                    yield Path(os.path.join(dirpath, filename))

        def exists(self):
            return os.path.exists(self)

        def is_dir(self):
            return os.path.isdir(self)

        def rename(self, newname):
            os.rename(self, newname)

        def joinpath(self, *args):
            return Path(os.path.join(self, *args))

        def __truediv__(self, other):
            return Path(os.path.join(self, other))


logging.basicConfig(level=logging.INFO)
DIR = Path(os.path.dirname(os.path.abspath(__file__)))

def download_url(url, output_dir=""):
    name = os.path.basename(url)
    output_dir and not os.path.isdir(output_dir) and os.makedirs(output_dir)
    output_path = os.path.join(output_dir, name)

    req = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    response = urlopen(req)
    with open(output_path, "wb") as fp:
        fp.write(response.read())
    return output_path


def get_vcvars():
    # NOTES(timmyliang): https://github.com/microsoft/vswhere/tree/main
    vs_where = os.path.join(os.getenv("ProgramFiles(x86)"), "Microsoft Visual Studio", "Installer", "vswhere.exe")
    assert os.path.exists(vs_where), "Please Install Visual Studio & Windows MSVC Compiler"
    location = subprocess.check_output([vs_where, "-find", "**/vcvars64.bat"])
    vcvars_bat = location.decode().strip()
    assert os.path.exists(vcvars_bat), "Please Install Visual Studio & Windows MSVC Compiler"
    return vcvars_bat


def build():
    vcvars_bat = get_vcvars()

    external_dir = DIR / "external"
    fbx_binding_dir = external_dir / "fbx_python_binding"
    fbx_sdk_dir = external_dir / "fbx_sdk"
    tmpdir = tempfile.mkdtemp()

    # NOTES(timmyliang): nsis silent install - https://nsis.sourceforge.io/Docs/Chapter3.html
    if not fbx_binding_dir.joinpath("uninstall.exe").exists():
        url = "https://www.autodesk.com/content/dam/autodesk/www/adn/fbx/2020-3-1/fbx202031_fbxpythonbindings_win.exe"
        logging.info("Download {url} ...".format(**locals()))
        installer = download_url(url, tmpdir)
        logging.info("Install {installer} ...".format(**locals()))
        subprocess.call([installer, "/S", "/D={fbx_binding_dir}".format(**locals())], shell=True)
    if not fbx_sdk_dir.joinpath("uninstall.exe").exists():
        url = "https://www.autodesk.com/content/dam/autodesk/www/adn/fbx/2020-3-1/fbx202031_fbxsdk_vs2015_win.exe"
        logging.info("Download {url} ...".format(**locals()))
        installer = download_url(url, tmpdir)
        logging.info("Install {installer} ...".format(**locals()))
        subprocess.call([installer, "/S", "/D={fbx_sdk_dir}".format(**locals())], shell=True)
    shutil.rmtree(tmpdir)

    # NOTES(timmyliang): extract zip files
    sip_zip = next(iter(external_dir.glob("sip*.zip")))
    assert sip_zip, "sip zip not found."
    flex_zip = next(iter(external_dir.glob("*flex*.zip")))
    assert flex_zip, "flex zip not found."

    sip_folder = external_dir / "sip"
    SIP_ROOT = next(iter(sip_folder.glob("sip*")), "")
    if not SIP_ROOT:
        logging.info("Extract {sip_zip} ...".format(**locals()))
        with zipfile.ZipFile(sip_zip, "r") as zip_ref:
            zip_ref.extractall(sip_folder)
        SIP_ROOT = next(iter(sip_folder.glob("sip*")), "")

    flex_folder = external_dir / "flex_bison"
    if not flex_folder.joinpath("bison.exe").exists():
        flex_folder.is_dir() and shutil.rmtree(flex_folder)
        logging.info("Extract {flex_zip} ...".format(**locals()))
        with zipfile.ZipFile(flex_zip, "r") as zip_ref:
            zip_ref.extractall(flex_folder)
        for exe_path in flex_folder.glob("*.exe"):
            exe_path.rename(exe_path.parent / exe_path.name.split("_")[-1])

    # NOTES(timmyliang): prepare env
    os.environ["SIP_ROOT"] = str(SIP_ROOT)
    os.environ["FBXSDK_ROOT"] = str(fbx_sdk_dir)
    os.environ["PATH"] = os.pathsep.join(os.getenv("PATH").split(os.pathsep) + [str(flex_folder)])

    # NOTES(timmyliang): prepare sip build
    build_script = os.path.join(SIP_ROOT, "build.py")
    subprocess.call([sys.executable, build_script, "prepare"], cwd=SIP_ROOT)

    # NOTES(timmyliang): build fbx.pyd
    script_path = fbx_binding_dir / "PythonBindings.py"
    major, minor = sys.version_info[:2]
    build_version = "Python{major}_x64".format(major=major)
    subprocess.call([vcvars_bat, "&", sys.executable, str(script_path), build_version, "buildsip"], cwd=os.getcwd())

    # NOTES(timmyliang): copy modified sip files into python binding folder
    version_folder = DIR / "{major}.{minor}".format(major=major, minor=minor)
    if version_folder.exists():
        shutil.rmtree(version_folder)
    os.mkdir(version_folder)

    build_dir = fbx_binding_dir / "build" / "Distrib"
    for path in build_dir.rglob("*.py*"):
        path.rename(version_folder / path.name)


if __name__ == "__main__":
    build()
