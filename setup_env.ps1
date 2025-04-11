# setup_env.ps1
# Script to configure Python env "nhmm" in Windows

Write-Host "🛠️  Creating virtual environment 'nhmm'..."
python -m venv nhmm

Write-Host "✅ Activating environment..."
.\nhmm\Scripts\Activate.ps1

Write-Host "📦 Installing dependencies from requirements.txt..."
pip install --upgrade pip
pip install -r requirements.txt

Write-Host "✅ Environment 'nhmm' is ready. To activate it later, run:"
Write-Host "`n    .\nhmm\Scripts\Activate.ps1`n"
