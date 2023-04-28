#/bin/bash 

WORK_DIR=$1
if [ -z "$WORK_DIR" ]; then
    echo "Usage: $0 <work_dir>"
    exit 1
fi

BRANCH=$2
if [ -z "$BRANCH" ]; then
    BRANCH=master
fi

REPO_DIR=$WORK_DIR/repo.git
FILES_DIR=$WORK_DIR/files

mkdir -p $REPO_DIR
mkdir -p $FILES_DIR

# create bare repo
cd $REPO_DIR
git init --bare
cd -

# create post receive hook
cat > $REPO_DIR/hooks/post-receive <<EOF
#!/bin/bash

REPO_DIR=$REPO_DIR
FILES_DIR=$FILES_DIR

git --work-tree=\$FILES_DIR --git-dir=\$REPO_DIR checkout -f $BRANCH
EOF

chmod +x $REPO_DIR/hooks/post-receive

echo "Bare repo created at $REPO_DIR"
