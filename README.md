# CKA Mock Quiz

![Docker Image](https://img.shields.io/badge/docker-ready-blue.svg)

A lightweight, static mock quiz for the [Certified Kubernetes Administrator (CKA)][cka] exam—packaged as a Docker-ready Nginx site.

---

## Table of Contents

1. [Overview](#overview)  
2. [Features](#features)  
3. [Prerequisites](#prerequisites)  
4. [Installation](#installation)  
5. [Usage](#usage) 
   - [Run on browser](#run-on-browser) 
   - [Run Locally (Static)](#run-locally-static)  
   - [Run with Docker](#run-with-docker)    
6. [Adding or Modifying Quiz Content](#adding-or-modifying-quiz-content)  
7. [Documentation](#documentation)  
8. [Contributing](#contributing)   
9. [Authors](#authors)  

---

## Overview

This repository contains a static, client-side mock quiz for the CKA exam, served via Nginx. It’s designed for self-study: clone, build, and spin up the quiz site in seconds.

## Features

- **100% static** HTML/CSS/JS—no backend required  
- **Dockerized** with Alpine-based Nginx for blazing-fast startup  
- Easily **extendable**: add or tweak questions in plain HTML/JS  
- Legacy entry point supported via `old_index.htm`

## Prerequisites

- Git
- Docker (for containerized deployment)  

> If you just want to open the quiz in your browser, you don’t need Docker.

## Installation

```bash
# 1. Clone the repo
git clone https://github.com/sr1ram/sr1ram.git
cd sr1ram
```

## Usage

## Run on browser 
You can access the quiz right away on https://sr1ram.github.io/sr1ram/ or directly from your VDI on .........

## Run Locally (static)

Simply open old_index.htm (or webp/index.html if you’ve renamed it) in your browser:

```bash
# from project root
open webp/index.html
```

## Run with docker

```bash 
# 1. Build the image
docker build -t cka-mock-quiz .

# 2. Run the container (exposes port 80)
docker run -d --name cka-quiz -p 80:80 cka-mock-quiz

# 3. Visit http://localhost in your browser
```

To stop and remove 

```bash
docker stop cka-quiz && docker rm cka-quiz
```

## Contributing

1. Fork the repository

2. Create a feature branch (git checkout -b feature/YourFeature)

3. Commit your changes (git commit -am 'Add some feature')

4. Push to the branch (git push origin feature/YourFeature)

5. Open a Pull Request

Please follow clean code practices and update this README if you add or change major functionality.


## Authors
sriramcw – Original author

sr1ram – Repo owner

John Fakile – Contributor



Made with :heart: for Kubernetes learners.



