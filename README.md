# fbx_python_bindings

Auto build fbx.pyd on windows.

## 📦Prerequisites

Install [Python](https://www.python.org/) & [Visual Studio](https://visualstudio.microsoft.com/downloads/) 

1. run `git clone git@github.com:FXTD-ODYSSEY/CMakeMaya.git` clone repo
2. run `python build.py` build `fbx.pyd` | `build.py` will do several things for you.
    1. download necessary `fbxsdk` & `fbx_python_binding` files into `External`
    2. extract `sip` & `win_flex_bison`
    3. setup compile environment
    4. compile the pyd & move to the root version folder

if you want to build different python version pyd, just use specified python interpreter run `build.py`.
`build.py` already py2 py3 compatible.

## 🔨run test

```Python
python -m unittest discover -s tests -p "test_*.py"
```

## ⚙Extra C++ Function

There are several python API lost according to [C++ docs](https://help.autodesk.com/view/FBX/2020/ENU/?guid=FBX_Developer_Help_cpp_ref_annotated_html)

- FbxCamera
    - EvaluateLookAtPosition
    - EvaluatePosition
    - EvaluateUpDirection
    - EvaluateUpDirection
    - ComputeScreenToWorld
