import os
import traceback

from decouple import config
from pathlib import Path
from subprocess import run as bashrun
from dotenv import load_dotenv

try:
    print("Default var for upstream repo & branch will used if none were given!")
    ALWAYS_DEPLOY_LATEST = getenv(
        "ALWAYS_DEPLOY_LATEST",
        default=True,
        cast=bool)
    AUPR = getenv("ALWAYS_UPDATE_PY_REQ", default=True, cast=bool)
    UPSTREAM_REPO = getenv("UPSTREAM_REPO")
    UPSTREAM_BRANCH = getenv("UPSTREAM_BRANCH")

except Exception:
    print("Environment vars Missing")
    traceback.print_exc()


def varsgetter(files):
    evars = ""
    if files.is_file():
        with open(files, "r") as file:
            evars = file.read().rstrip()
            file.close()
    return evars


def varssaver(evars, files):
    if evars:
        file = open(files, "w")
        file.write(str(evars) + "\n")
        file.close()


r_filep = Path("Auto-rename.txt")
rvars = varsgetter(r_filep)
update_check = Path("update")
cmd = (
    f"git switch {UPSTREAM_BRANCH} -q \
    && git pull -q "
    "&& git reset --hard @{u} -q \
    && git clean -df -q"
)
cmd2 = f"git init -q \
       && git config --global user.email 117080364+Niffy-the-conqueror@users.noreply.github.com \
       && git config --global user.name Niffy-the-conqueror \
       && git add . \
       && git commit -sm update -q \
       && git remote add origin {UPSTREAM_REPO} \
       && git fetch origin -q \
       && git reset --hard origin/{UPSTREAM_BRANCH} -q \
       && git switch {UPSTREAM_BRANCH} -q"

try:
    if ALWAYS_DEPLOY_LATEST is True or update_check.is_file():
        if os.path.exists('.git'):
            update = bashrun([cmd], shell=True)
        else:
            update = bashrun([cmd2], shell=True)
        if AUPR:
            bashrun(["pip3", "install", "-r", "requirements.txt"])
        if update.returncode == 0:
            print('Successfully updated with latest commit from UPSTREAM_REPO')
        else:
            print('Something went wrong while updating,maybe invalid upstream repo?')
        if update_check.is_file():
            os.remove("update")
        varssaver(rvars, r_filep)
    else:
        print("Auto-update is disabled.")
except Exception:
    traceback.print_exc()
