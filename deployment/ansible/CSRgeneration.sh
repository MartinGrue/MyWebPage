domainname=$1
shift
for sub in "$@"
do
    subdomain+="DNS:$sub.$domainname,"
done
subdomain=${subdomain::-1}
openssl req -new -sha256 \
-key /etc/letsencrypt/keys/$domainname.key \
-subj /CN=$domainname -reqexts SAN \
-config <(printf "\n[SAN]\nsubjectAltName=DNS:$domainname,$subdomain" | cat /etc/ssl/openssl.cnf -) \
| tee /etc/letsencrypt/csrs/$domainname.csr
