# GitHub Actions Self-Hosted Runner — Beginner's Guide (Windows + Python)

## What is a Self-Hosted Runner?

When you use GitHub Actions, by default your workflow runs on **GitHub's cloud servers** (called "GitHub-hosted runners"). These are free but have limits.

A **self-hosted runner** means you register **your own Windows PC or server** as the machine that runs your workflows. This is useful when you:

- Need software only installed on your machine
- Want to use more CPU/RAM than GitHub provides for free
- Need to stay on a private network
- Want to learn how CI/CD works at a deeper level

```
Normal Flow:          Self-Hosted Flow:
GitHub Push           GitHub Push
    |                     |
GitHub Cloud  →→→→    YOUR Machine
(ubuntu-latest)       (Windows PC)
```

---

## Project Structure

```
Github_SelfRunner/
│
├── .github/
│   └── workflows/
│       └── self-hosted-runner-demo.yml   ← The CI/CD pipeline definition
│
├── calculator.py        ← Simple Python app (our code to test)
├── test_calculator.py   ← Automated tests using pytest
├── requirements.txt     ← Python packages needed
└── README.md            ← This file
```

---

## Step 1 — Prerequisites (Install on Your Windows Machine)

Make sure the following are installed:

| Software | Download Link | Check if installed |
|----------|--------------|-------------------|
| Python 3.11+ | https://python.org/downloads | `python --version` |
| Git | https://git-scm.com/download/win | `git --version` |
| GitHub account | https://github.com | — |

---

## Step 2 — Create a GitHub Repository

1. Go to [github.com](https://github.com) → Click **New Repository**
2. Name it `Github_SelfRunner`
3. Leave it **Public** or **Private** (both work)
4. Do **NOT** initialize with README (you already have files)
5. Click **Create repository**

Then push this project to it from PowerShell:

```powershell
cd d:\KJC\DevOps\Github_SelfRunner
git init
git add .
git commit -m "First commit - self-hosted runner demo"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/Github_SelfRunner.git
git push -u origin main
```

> Replace `YOUR_USERNAME` with your actual GitHub username.

---

## Step 3 — Register Your Windows Machine as a Self-Hosted Runner

1. Go to your GitHub repository
2. Click **Settings** → **Actions** → **Runners**
3. Click **New self-hosted runner**
4. Select **Windows** as the operating system
5. Follow the commands shown on screen — they look like this:

### Download the runner (PowerShell as Administrator)

```powershell
# Create a folder for the runner
mkdir C:\actions-runner ; cd C:\actions-runner

# Download the runner package (GitHub will show the exact version)
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.xxx.x/actions-runner-win-x64-2.xxx.x.zip -OutFile actions-runner-win-x64.zip

# Extract it
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\actions-runner-win-x64.zip", "$PWD")
```

### Configure the runner (GitHub gives you a unique token)

```powershell
# This command is shown on GitHub — it has YOUR unique token
.\config.cmd --url https://github.com/YOUR_USERNAME/Github_SelfRunner --token YOUR_TOKEN_HERE
```

You will be asked:
- **Runner group**: Press Enter (use default)
- **Runner name**: Type a name like `my-windows-pc` or press Enter
- **Labels**: You can add `windows,python` or press Enter
- **Work folder**: Press Enter (use default `_work`)

### Start the runner

```powershell
# Run manually (stays running while PowerShell window is open)
.\run.cmd
```

You should see:
```
√ Connected to GitHub
Listening for Jobs
```

> **Tip for production**: Install it as a Windows Service so it starts automatically:
> ```powershell
> .\svc.cmd install
> .\svc.cmd start
> ```

---

## Step 4 — Trigger the Workflow

After the runner is listening, trigger the workflow by pushing a change:

```powershell
cd d:\KJC\DevOps\Github_SelfRunner
echo "# trigger" >> README.md
git add .
git commit -m "Trigger self-hosted runner workflow"
git push
```

Then go to your GitHub repository → **Actions** tab → watch the workflow run on YOUR machine!

---

## Step 5 — Understand the Workflow File

Open [.github/workflows/self-hosted-runner-demo.yml](.github/workflows/self-hosted-runner-demo.yml)

The most important line is:

```yaml
runs-on: self-hosted
```

This is what tells GitHub: **"Don't use your cloud — use my registered machine."**

Compare the two options:

| `runs-on: ubuntu-latest` | `runs-on: self-hosted` |
|--------------------------|------------------------|
| GitHub's cloud machine | YOUR Windows machine |
| Fresh environment every run | Persistent environment |
| Limited free minutes | No minute limits |
| No access to local files | Can access local network |

---

## Step 6 — Run Locally to Test First

Before pushing, always test your code locally:

```powershell
cd d:\KJC\DevOps\Github_SelfRunner

# Install dependencies
pip install -r requirements.txt

# Run the app
python calculator.py

# Run the tests
pytest test_calculator.py -v
```

Expected test output:
```
test_calculator.py::TestAdd::test_add_positive_numbers   PASSED
test_calculator.py::TestAdd::test_add_negative_numbers   PASSED
test_calculator.py::TestAdd::test_add_zero               PASSED
test_calculator.py::TestSubtract::test_subtract_positive_numbers  PASSED
test_calculator.py::TestSubtract::test_subtract_negative_result   PASSED
test_calculator.py::TestMultiply::test_multiply_positive_numbers  PASSED
test_calculator.py::TestMultiply::test_multiply_by_zero  PASSED
test_calculator.py::TestDivide::test_divide_positive_numbers      PASSED
test_calculator.py::TestDivide::test_divide_by_zero_raises_error  PASSED

9 passed in 0.XXs
```

---

## Common Issues & Fixes

| Problem | Cause | Fix |
|---------|-------|-----|
| Runner shows "Offline" | `run.cmd` not running | Run `.\run.cmd` in PowerShell |
| `python` not found | Python not in PATH | Reinstall Python, check "Add to PATH" |
| Permission denied | Not running as Admin | Open PowerShell as Administrator |
| Token invalid | Token expired (1 hour) | Get a new token from GitHub Settings |
| Workflow not triggering | Wrong branch name | Check `branches: [ "main" ]` matches your branch |

---

## Key Concepts Summary

| Term | Meaning |
|------|---------|
| **Runner** | The machine that executes your workflow jobs |
| **Self-hosted runner** | Your own machine registered with GitHub |
| **Workflow** | A YAML file defining automation steps |
| **Job** | A group of steps that run on one runner |
| **Step** | A single action (run a command, install a package, etc.) |
| **`runs-on`** | Specifies which runner to use for a job |
| **`workflow_dispatch`** | Allows manually triggering a workflow from GitHub UI |

---

## Next Steps for Students

1. **Add a new function** to `calculator.py` (e.g., `power(a, b)`)
2. **Write a test** for it in `test_calculator.py`
3. **Push your changes** and watch the runner execute your tests automatically
4. **Intentionally break a test** — see how GitHub shows a failed workflow
5. **Add a new step** to the workflow YAML (e.g., print today's date)
