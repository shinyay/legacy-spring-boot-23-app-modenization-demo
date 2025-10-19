#!/bin/bash

echo "Post-create script starting..."

# Set Java 8 as default in SDKMAN
echo "Setting Java 8 as default..."
if [ -d "/usr/local/sdkman/candidates/java/8.0.462-tem" ]; then
    export SDKMAN_DIR="/usr/local/sdkman"
    if [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
        sdk default java 8.0.462-tem 2>/dev/null || echo "Setting Java 8 as default via SDKMAN"
    fi
    # Update the symlink directly to ensure Java 8 is default
    rm -f /usr/local/sdkman/candidates/java/current
    ln -sf /usr/local/sdkman/candidates/java/8.0.462-tem /usr/local/sdkman/candidates/java/current
    echo "Java 8 set as default"
    java -version
fi

# Install frontend dependencies
if [ -f "/workspace/frontend/package.json" ]; then
    echo "Installing frontend dependencies..."
    cd /workspace/frontend
    npm install
fi

# Make Maven wrapper executable
if [ -f "/workspace/backend/mvnw" ]; then
    chmod +x /workspace/backend/mvnw
fi

# Create VS Code settings for Java development
echo "Setting up VS Code Java configuration..."
VSCODE_DIR="/workspace/.vscode"
SETTINGS_FILE="$VSCODE_DIR/settings.json"

# Create .vscode directory if it doesn't exist
mkdir -p "$VSCODE_DIR"

# Detect Java Home path in Dev Container environment
JAVA_HOME_PATH=""
if [ -d "/usr/local/sdkman/candidates/java/8.0.462-tem" ]; then
    JAVA_HOME_PATH="/usr/local/sdkman/candidates/java/8.0.462-tem"
elif [ -d "/usr/local/sdkman/candidates/java/current" ]; then
    JAVA_HOME_PATH="/usr/local/sdkman/candidates/java/current"
elif [ ! -z "$JAVA_HOME" ]; then
    JAVA_HOME_PATH="$JAVA_HOME"
else
    echo "Warning: Could not detect Java Home path"
    JAVA_HOME_PATH="/usr/local/sdkman/candidates/java/8.0.462-tem"
fi

echo "Detected Java Home: $JAVA_HOME_PATH"

# Create or update VS Code settings.json
cat > "$SETTINGS_FILE" << EOF
{
    "java.jdt.ls.java.home": "$JAVA_HOME_PATH",
    "java.home": "$JAVA_HOME_PATH",
    "java.configuration.runtimes": [
        {
            "name": "JavaSE-1.8",
            "path": "$JAVA_HOME_PATH",
            "default": true
        }
    ],
    "maven.executable.path": "/usr/bin/mvn"
}
EOF

echo "VS Code Java settings created at $SETTINGS_FILE"

# Configure user's bashrc for Java 8
echo "Configuring bashrc for Java 8..."
if ! grep -q "SDKMAN Configuration" /home/vscode/.bashrc; then
    cat >> /home/vscode/.bashrc << 'EOFBASH'

# SDKMAN Configuration
export SDKMAN_DIR="/usr/local/sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Ensure Java 8 is the default
export JAVA_HOME=/usr/local/sdkman/candidates/java/8.0.462-tem
export PATH=$JAVA_HOME/bin:$PATH
EOFBASH
    echo "Java 8 configuration added to bashrc"
else
    echo "SDKMAN configuration already exists in bashrc"
fi

echo "Post-create script completed."
