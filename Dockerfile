# ---- Builder Stage ----
# This stage builds the Python environment with all dependencies.
FROM python:3.12-slim AS builder
WORKDIR /app

# Install build dependencies needed for compiling packages like gevent
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gcc libffi-dev libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip and install all packages into the venv
RUN pip install --upgrade pip setuptools wheel
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# ---- Final Stage ----
# This stage creates the final, lean image.
FROM python:3.12-slim
WORKDIR /app

# Install runtime dependencies (curl for healthcheck)
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the virtual environment from the builder stage
COPY --from=builder /opt/venv /opt/venv

# Create a non-root user for security
RUN useradd -m appuser && \
    chown -R appuser:appuser /app

# Copy application code as the non-root user
COPY --chown=appuser:appuser . .

# Activate the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV PORT=8080
ENV HOST=0.0.0.0

# Switch to the non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Run Flask application
CMD ["python3", "app.py"]