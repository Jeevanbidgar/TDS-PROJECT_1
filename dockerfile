# Use a lightweight Python base image
FROM python:3.12-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

# Download and install uv
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN chmod +x /uv-installer.sh && sh /uv-installer.sh && rm /uv-installer.sh

# Install required Python dependencies
RUN pip install --no-cache-dir fastapi uvicorn openai requests pytesseract pillow numpy python-dotenv scipy python-dateutil

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin:$PATH"

# Set up the application directory
WORKDIR /app

# Copy all project files
COPY . .

# Run the application (use python instead of uv if issues arise)
CMD [ "python", "app.py"]
