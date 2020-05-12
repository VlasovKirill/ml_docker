from notebook.auth import passwd
string = passwd()

with open('~/.jupyter/jupyter_notebook_config.py', 'wb') as config:
    config.write(f'c.NotebookApp.password = \'{string}\'')
    config.write(f'c.NotebookApp.token = \'\'')

