read about this project - https://blog.astralelite.org

## Direct Run - Container - v1.0.0
visit and get api - https://aistudio.google.com/app/apikey
```bash
docker run -p 8080:8000 --name xue-ai -e GOOGLE_API_KEY=... -d ghcr.io/astralelite-open-source/xue-ai:v1.0.0
```
http://localhost:8080

# Installation Guide

```bash
git clone https://github.com/AstralElite-open-source/xue-ai.git
```
```bash
pip install -r requirements.txt
```
Create .env file
```text
GOOGLE_API_KEY=your gemini api
```
```bash
python app.py
```
## Docker Image Build  Run & stop Guide - make sure you have setup your .env file with gemini api

```bash
docker build -t xue-ai:latest .
```
```bash
docker run -d -p 8080:8080 --name xue-ai xue-ai:latest
```
```bash
http://localhost:8080
```
```bash
docker stop xue-ai   # running container will stop
```
