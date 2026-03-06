#!/bin/bash

# --- 1. Preparação do Terreno ---
sudo apt update && sudo apt upgrade -y
sudo apt install -y git python3 python3-pip golang curl jq libpcap-dev ruby-full nm-connection-editor

# Configurando o ambiente GO
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc

echo "🛠️ Iniciando a instalação do Top 30..."

# --- 2. Recon & Subdomínios (Onde tudo começa) ---
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/owasp-amass/amass/v4/...@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/projectdiscovery/shodan-cli/cmd/shodan@latest

# --- 3. Port Scanning & HTTP Probing (Validação) ---
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
sudo apt install -y nmap

# --- 4. Vulnerability Scanners (O "Suco") ---
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
sudo apt install -y nikto wpscan sqlmap
nuclei -ut # Atualiza templates de vulnerabilidades

# --- 5. Content Discovery & Fuzzing ---
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/oj/gobuster/v3@latest
sudo apt install -y dirb

# --- 6. URL Discovery & Endpoint Extraction ---
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest

# --- 7. Análise de Parâmetros e JS ---
go install -v github.com/tomnomnom/gf@latest
go install -v github.com/tomnomnom/qsreplace@latest
go install -v github.com/s0md3v/Arjun@latest
go install -v github.com/hahwul/dalfox/v2@latest

# Configurando GF Patterns (Crucial para filtrar XSS, SSRF, LFI)
mkdir -p ~/.gf
git clone https://github.com/1ndianl33t/Gf-Patterns
cp Gf-Patterns/*.json ~/.gf/

# --- 8. Fingerprinting & Cloud ---
sudo apt install -y whatweb
go install -v github.com/projectdiscovery/wappalyzergo/cmd/update-fingerprints@latest
pip3 install s3scanner cloud-scanner

# --- 9. Utilitários de Workflow (Os que salvam tempo) ---
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/tomnomnom/unfurl@latest
go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest

# --- 10. Organização Final ---
sudo cp ~/go/bin/* /usr/local/bin/

echo "✅ [CONCLUÍDO] Você agora tem as 30+ ferramentas mais poderosas do Bug Bounty instaladas!"
