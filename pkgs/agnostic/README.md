# Agnostic

Config files that are platform-agnostic and should be able to work on Windows, MacOS or Linux. These are for globally installed python and node.js packages which have high general utility.

To install python packages with `pip`:

```bash
python -m pip install -r py-requirements.txt
```

To install node.js packages with `npm` (it's a bit janky I know):

```bash
npm install -g $(cat npm-packages.txt)
```

