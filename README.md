# Bug Bounty Methodology

---

## Table of Contents
- [Recon](#recon)
- [Vulnerability Discovery](#vulnerability-discovery)
- [Manual Testing (Validation & Exploitation)](#manual-testing-validation--exploitation)
- [Post-Exploitation (Pivoting & Data Exfiltration)](#post-exploitation-pivoting--data-exfiltration)
- [Reporting & Disclosure](#reporting--disclosure)

---

## Recon

During the **reconnaisance** stage, we want to __learn__ as much about the target as possible.

### Google Dorking

We can use Google Dorking to find valuable information on the internet, with a customized, targeted Google search (or Dork)!

[Google Dorking Commands](google_dorking/README.md)
[Google Dorking Script](google_dorking/script.py)

### Tech Profiling

Determine what technologies the target uses.

**Browser Extensions**:
1. [WhatRuns](https://www.whatruns.com/)
2. [Wappalyzer](https://www.wappalyzer.com/)
   - Default on Kali Linux
  
**Command Line**:
1. [WebAnalyze](https://github.com/rverton/webanalyze)
   - Command Line: `webanalyze -host https://example.com -crawl 2`

### Subdomain Enumeration
1. [SubFinder](https://github.com/projectdiscovery/subfinder): `subfinder -d target.com -o subdomains.txt`
2. [AssetFinder](https://github.com/tomnomnom/assetfinder): `assetfinder --subs-only target.com >> subdomains.txt`
3. [Amass](https://github.com/owasp-amass/amass): `amass enum -passive -d target.com >> subdomains.txt`

### Port Scanning & Service Detection
1. [Naabu](https://github.com/projectdiscovery/naabu): `naabu -host target.com -ports full -o open-ports.txt`
2. [RustScan](https://github.com/RustScan/RustScan): `rustscan -a target.com -b 500 -u 5000 -- -sV -sC`
3. [Nmap](https://nmap.org/): `nmap -sC -sV target.com`

### Crawling & Directory Busting
1. [HakRawler](https://github.com/hakluke/hakrawler): `hakrawler -all -url https://target.com -depth 3 -subs -out urls.txt`
2. [GoSpider](https://github.com/jaeles-project/gospider): `gospider -s https://target.com -o spidered_urls.txt`
3. [FeroxBuster](https://github.com/epi052/feroxbuster): `feroxbuster -u https://target.com -t 50 -o directories.txt`

### Other OSINT Tools
1. [Shodan](https://www.shodan.io/)
   - Find open ports, services, and banners
   - GUI
   - Command Line
2. [Censys](https://censys.io)
   - Search for exposed assets
3. [WayBack Machine](https://waybackmachine.org)
   - Find old endpoints
   - GUI
   - Command Line: `waybackurls target.com`
4. [Gau](https://github.com/lc/gau)
   - Find old endpoints
   - Command Line: `gau target.com | tee gau-urls.txt`
---

## Vulnerability Discovery

Whew. Now that we have got the boring (though pretty important) stuff out of the way, we can get to the fun stuff.

During this stage, we will test for (mostly through automation) vulnerabilities. To seperate ourselves from the rest of the pack, we must customize our tools to stay ahead of the curve!

### Automated Vulnerability Scanning
1. [Nuclei](https://projectdiscovery.io/nuclei) for Mass Scanning
- `nuclei -l subdomains.txt -t cves/ -o nuclei-findings.txt`
- `nuclei -list subdomains.txt -t vulnerabilities/ -o vulnerabilities.txt`

### XSS & SQLi Testing
1. [KXSS](https://github.com/Emoe/kxss): `kxss < urls.txt`
2. [DalFox](https://github.com/hahwul/dalfox): `dalfox url -b vuln.burpcollaborator.net -o xss-findings.txt`
3. [SQLMap](https://sqlmap.org/): `sqlmap -u "https://target.com?id=1" --batch --dbs`

### CMS-Specific Exploits
1. [WPScan](https://wpscan.com/): `wpscan --url https://target.com --api-token <API_KEY> -o wordpress-findings.txt`
2. [JoomScan](https://github.com/OWASP/joomscan): `joomscan -u https://target.com`

### Parameter & Hidden Endpoint Discovery
1. [Arjun](https://github.com/s0md3v/Arjun): `arjun -u https://target.com`
2. [ParamSpider](https://github.com/devanshbatham/ParamSpider): `paramspider -d target.com -o parameters.txt`

---

## Manual Testing (Validation & Exploitation)

After automation, manual verification is crucial to avoid false positives...

---

## Post-Exploitation (Pivoting & Data Exfiltration)

### Privilege Escalation
1. Check misconfigured Sudo permissions
2. Look for leaked .git or .env files

### Pivoting (Internal Network)
1. Exploit SSRF → Pivot into internal subnets
2. Use chisel or ligolo for tunneling

---

## Reporting & Disclosure

Make sure you document your findings clearly.

Include:
1. Vulnerability Name
2. Affected Endpoint
3. Impact
4. Steps to Reproduce
5. Proof of Concept (PoC)
6. Remediation Suggestions

---

## Conclusion

The approach to each target will be unique. Think through your process, and ensure that all actions you take are with purpose, and **legal**.
