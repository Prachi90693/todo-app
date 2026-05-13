# Start from official Python 3.11 on minimal Linux
# This image already has Python installed — you don't need to
FROM python:3.11-slim

# Set the working directory inside the container
# All future commands run from this folder
WORKDIR /app

# Copy requirements.txt FIRST (before the rest of your code)
# WHY: Docker caches each step. If requirements.txt hasn't changed,
# it skips pip install on the next build — saving you 30+ seconds
COPY requirenments.txt .
# Install Flask inside the container
RUN pip install --no-cache-dir -r requirenments.txt

# Now copy everything else (app.py, templates/, etc.)
COPY . .

# Document that the app uses port 5000
EXPOSE 5000
# The command that runs when a container starts
# List format ["python","app.py"] is safer than "python app.py"
CMD ["python", "app.py"]