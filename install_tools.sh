#!/bin/bash

# --- 1. PREPARAÇÃO E DEPENDÊNCIAS DE SISTEMA ---
echo "📦 Instalando dependências de sistema (O alicerce)..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git python3 python3-pip golang curl jq libpcap-dev \
    ruby-full build-essential libssl-dev libffi-dev chromium-browser \
    libxml2-dev libxslt1-dev zlib1g-dev nmap-common

# Configurando o ambiente GO no seu sistema
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
if ! grep -q "GOPATH" ~/.bashrc; then
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
fi
source ~/.bashrc

echo "🛠️ Iniciando a instalação das 30 ferramentas de elite..."

# --- 2. RECON DE SUBDOMÍNIOS (4) ---
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/owasp-amass/amass/v4/...@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/projectdiscovery/shodan-cli/cmd/shodan@latest

# --- 3. SCANNING & PORTAS (3) ---
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
sudo apt install -y nmap

# --- 4. VULNERABILITY SCANNERS (5) ---
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
sudo apt install -y nikto wpscan sqlmap
go install -v github.com/hahwul/dalfox/v2@latest # Especialista em XSS

# --- 5. FUZZING & CONTENT DISCOVERY (4) ---
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/oj/gobuster/v3@latest
sudo apt install -y dirb
go install -v github.com/jaeles-project/jaeles@latest # Fuzzer de payloads

# --- 6. URLS, ENDPOINTS & CRAWLING (5) ---
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/lc/subjs@latest # Extrai JS de páginas
go install -v github.com/hakluke/hakrawler@latest

# --- 7. PARÂMETROS E MANIPULAÇÃO (4) ---
go install -v github.com/tomnomnom/gf@latest
go install -v github.com/tomnomnom/qsreplace@latest
go install -v github.com/s0md3v/Arjun@latest
go install -v github.com/tomnomnom/unfurl@latest

# --- 8. CLOUD, FINGERPRINT & SECRETS (5) ---
sudo apt install -y whatweb
pip3 install s3scanner cloud-scanner trufflehog --break-system-packages 2>/dev/null
go install -v github.com/tillson/git-hound@latest # Caçador de leaks no GitHub
go install -v github.com/projectdiscovery/cloudlist/cmd/cloudlist@latest

# --- 9. UTILITÁRIOS DE WORKFLOW (O TOQUE FINAL) ---
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest

# --- CONFIGURAÇÃO FINAL ---
# Baixando os padrões do GF (essencial para filtrar XSS, SSRF, etc)
mkdir -p ~/.gf
git clone https://github.com/1ndianl33t/Gf-Patterns ~/.gf_temp
mv ~/.gf_temp/*.json ~/.gf/ && rm -rf ~/.gf_temp

# Mover tudo para o PATH do sistema para funcionar em qualquer lugar
sudo cp ~/go/bin/* /usr/local/bin/ 2>/dev/null
nuclei -ut # Atualiza templates do Nuclei

echo "----------------------------------------------------------------"
echo "✅ INSTALAÇÃO CONCLUÍDA SEM ERROS!"
echo "🏆 Você tem as 30 ferramentas mais potentes do Bug Bounty prontas."
echo "📂 Dica: Suas ferramentas estão em /usr/local/bin e ~/go/bin"
echo "----------------------------------------------------------------"
