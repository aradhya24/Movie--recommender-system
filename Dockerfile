# Stage 1: Build Stage
FROM python:3.9-slim AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the build stage
COPY requirements.txt ./

# Install dependencies in the build stage
RUN pip install --user --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Stage 2: Production Stage
FROM python:3.9-slim

# Set the working directory for the final image
WORKDIR /app

# Copy the dependencies from the build stage
COPY --from=builder /root/.local /root/.local

# Copy the application code from the build stage
COPY --from=builder /app /app

# Update PATH environment variable to use pip installed in local user directory
ENV PATH=/root/.local/bin:$PATH

# Expose the port that the app will run on
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
