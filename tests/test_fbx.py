import os
import sys
import logging
import fnmatch
import unittest
import subprocess

logging.basicConfig(level=logging.INFO)
ROOT = os.path.abspath(os.path.join(__file__, "..", ".."))
major, minor = sys.version_info[:2]
MODULE = os.path.join(ROOT, "{major}.{minor}".format(major=major, minor=minor))
MODULE not in sys.path and sys.path.insert(0, MODULE)

# NOTES(timmyliang): add python path into env
os.environ["PYTHONPATH"] = os.pathsep.join(os.getenv("PYTHONPATH", "").split(os.pathsep) + [MODULE])

fbx_path = os.path.join(MODULE, "fbx.pyd")
if not os.path.exists(fbx_path):
    logging.warning("Please Compile the fbx.pyd into `{MODULE}`".format(MODULE=MODULE))
    sys.exit()

import fbx
import FbxCommon
from fbx import FbxCamera

def glob_files(root, pattern):
    for dirpath, dirnames, filenames in os.walk(root):
        for filename in fnmatch.filter(filenames, pattern):
            yield os.path.join(dirpath, filename)


class TestStringMethods(unittest.TestCase):
    def test_samples(self):
        samples_dir = os.path.join(ROOT, "external", "fbx_python_binding", "samples")
        if not os.path.isdir(samples_dir):
            logging.warning("Please Run build.py to download `fbx_python_binding`")
            return

        fbx_path = os.path.join(samples_dir, "SplitMeshPerMaterial", "multiplematerials.fbx")
        for py_path in glob_files(samples_dir, "*.py"):
            py_dir, name = os.path.split(py_path)
            commands = [sys.executable, py_path]

            if name.startswith("SplitMeshPerMaterial"):
                commands += [fbx_path]
            elif name.startswith("ImportScene"):
                commands += [fbx_path]

            subprocess.check_call(commands, shell=True, cwd=py_dir)

    def test_api(self):
        # NOTES(timmyliang): add custom api
        FbxCamera.EvaluateLookAtPosition
        FbxCamera.EvaluatePosition
        FbxCamera.EvaluateUpDirection
        FbxCamera.ComputeProjectionMatrix
        FbxCamera.ComputeScreenToWorld


if __name__ == "__main__":
    unittest.main()
