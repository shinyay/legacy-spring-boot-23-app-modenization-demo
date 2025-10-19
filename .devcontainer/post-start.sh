#!/bin/bash

echo "Post-start script starting..."

# Set Java 8 as default in SDKMAN
echo "Setting Java 8 as default..."
if [ -d "/usr/local/sdkman/candidates/java/8.0.462-tem" ]; then
    export SDKMAN_DIR="/usr/local/sdkman"
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk default java 8.0.462-tem 2>/dev/null || echo "Java 8 already set as default"
    # Update the symlink directly as a fallback
    rm -f /usr/local/sdkman/candidates/java/current
    ln -sf /usr/local/sdkman/candidates/java/8.0.462-tem /usr/local/sdkman/candidates/java/current
    echo "Java 8 set as default"
    java -version
fi

# Ensure databases are ready
echo "Waiting for databases to be ready..."
sleep 5

# Check PostgreSQL connection
echo "Checking PostgreSQL connection..."
for i in {1..30}; do
    if pg_isready -h db -p 5432 >/dev/null 2>&1; then
        echo "PostgreSQL is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "Warning: PostgreSQL is not responding after 30 attempts"
    fi
    sleep 1
done

# Check Redis connection
echo "Checking Redis connection..."
for i in {1..30}; do
    if timeout 3 bash -c "</dev/tcp/redis/6379" >/dev/null 2>&1; then
        echo "Redis is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "Warning: Redis is not responding after 30 attempts"
    fi
    sleep 1
done

echo "Post-start script completed."
