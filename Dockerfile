# Stage 1: build dependencies
FROM python:3.11-slim AS builder

WORKDIR /build

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: minimal runtime image
FROM python:3.11-slim

# Run as non-root user (security best practice)
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

# Copy installed packages from builder stage
COPY --from=builder /install /usr/local

# Copy app code
COPY app.py .
COPY templates/ templates/
COPY requirements.txt .

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
