#!/bin/bash

# Convert the working directory to an absolute path
WORK_DIR=$(readlink -f "$1")
if [ -z "$WORK_DIR" ]; then
    echo "Usage: $0 <work_dir>"
    exit 1
fi

# Set the branch name, default to 'master' if not provided
BRANCH=${2:-master}

# Define repo and files directories
REPO_DIR="$WORK_DIR/repo.git"
FILES_DIR="$WORK_DIR/files"

# Create directories if they don't exist
mkdir -p "$REPO_DIR"
mkdir -p "$FILES_DIR"

# Create a bare repo
cd "$REPO_DIR" || exit
git init --bare
cd - || exit

# Create a post-receive hook
cat > "$REPO_DIR/hooks/post-receive" <<EOF
#!/bin/bash

REPO_DIR=$REPO_DIR
FILES_DIR=$FILES_DIR

git --work-tree="\$FILES_DIR" --git-dir="\$REPO_DIR" checkout -f $BRANCH
EOF

# Make the post-receive hook executable
chmod +x "$REPO_DIR/hooks/post-receive"

# Output the location of the bare repo
echo "Bare repo created at $REPO_DIR"
