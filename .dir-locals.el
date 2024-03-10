;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((python-mode . ((flycheck-flake8-maximum-line-length . 200)
                 (flycheck-checker . python-flake8)
                 (flycheck-python-pylint-executable . "~/miniconda3/envs/default/bin/pylint")
                 (flycheck-python-flake8-executable . "~/miniconda3/envs/default/bin/flake8")
                 (flycheck-python-pycompile-executable . "~/miniconda3/envs/default/bin/python")
                 (python-shell-interpreter . "~/miniconda3/envs/default/bin/python")
                 (flycheck-python-ruff-executable . "~/miniconda3/envs/default/bin/ruff")
                 (flycheck-python-pyright-executable . "~/miniconda3/envs/default/bin/pyright")
                 (flycheck-python-mypy-executable . "~/miniconda3/envs/default/bin/mypy")
                 (python-environment . "PYTHONPATH=~/hrc/"))))
