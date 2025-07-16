read about this project - https://blog.astralelite.org

# Installation Guide

```bash
git clone https://github.com/AstralElite-open-source/xue-ai.git
```
```bash
pip install -r requirements.txt
```
Crete .env file
```text
GOOGLE_API_KEY=your gemini api
```

## Docker Image Build  Run & stop Guide - make sure you setup .env file with gemini api

```bash
docker build -t xue-ai:latest .
```
```bash
docker run -d -p 3000:3000 --name xue-ai xue-ai:latest
```
```bash
docker stop xue-ai   # running container will stop
```
