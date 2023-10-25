# Startup script for interactive Python shells
# To be symlinked to ~/.config/pythonstartup.py

import csv, datetime as dt, json, math, os, sys, collections

try:
    import pandas as pd
except ImportError:
    pass
try:
    import numpy as np
except ImportError:
    pass

