#!/bin/bash

mkdir -p $HOME/jellyfin/config
mkdir -p $HOME/jellyfin/cache
mkdir -p $HOME/jellyfin/media
mkdir -p $HOME/jellyfin/media2

docker compose up -d