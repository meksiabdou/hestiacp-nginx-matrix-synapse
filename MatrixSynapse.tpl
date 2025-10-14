server {
    listen      %ip%:%proxy_port%;
    server_name %domain_idn% %alias_idn%;
    error_log  /var/log/%web_system%/domains/%domain%.error.log error;

    include %home%/%user%/conf/web/%domain%/nginx.forcessl.conf*;

    # ✅ Serve Let's Encrypt challenge directly
    location ^~/.well-known/acme-challenge/ {
        alias %home%/%user%/web/%domain%/public_html/.well-known/acme-challenge/;
        default_type "text/plain";
        try_files $uri=404;
        allow all;
    }

    location / {
        proxy_pass       http://localhost:8008;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header X-NginX-Proxy true;
    }

    location /error/ {
        alias  %home%/%user%/web/%domain%/document_errors/;
    }

    location @fallback {
        proxy_pass http://localhost:8008;
    }

    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}

    include %home%/%user%/conf/web/%domain%/nginx.conf_*;
}