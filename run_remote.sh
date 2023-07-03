#!/bin/bash
# Compute gives following variables
# 1. OPEN_APP_ID Is the url route that invokes the docker compute.polly.elucidata.io/shiny/app_direct/{uuid}/cellxgene/?dataset_id=jjfeje&repo_name=feffwef&repo_id=rfrfw
# 2. POLLY_REFRESH_TOKEN, POLLY_ID_TOKEN, POLLY_WORKSPACE_ID, POLLY_USER, POLLY_AUD, POLLY_SUB
# 3. discover py package and download the data
# 4. port of in which data is exposed should begiven to compute
# OPEN_APP_ID="https://compute.polly.elucidata.io/shiny/app_direct/3931a38ff367832c23d8c07aeea72a44/elucidata/4cpu8gbram3-6-2r/rnaseq_downstream_shiny/?_state_id_=&run_id=65942&parent_id=1685421500726&env=prod&run-id=65942&workspace-id=8020&workspaceId=8020"

if [ -n "$OPEN_APP_ID" ]; then
    echo 'Starting the run for Polly'
    IFS='?' read -ra parts <<< "$OPEN_APP_ID"
    COMPUTE_DOCKER_PATH="${parts[0]}"
    COMPUTE_DOCKER_PATH_API="'${COMPUTE_DOCKER_PATH}VIP','/VIP','VIP'];"
    PATH_TO_INDEX_INSERT="'${COMPUTE_DOCKER_PATH}static/interface.html',"
    sed '89 c\
            url: '$PATH_TO_INDEX_INSERT /index.html > /tmp_index.html
    # cat /tmp_index.html > /index.html
    cp index.html /opt/conda/envs/VIP/lib/python3.8/site-packages/server/common/web/templates/index.html
    cp /opt/conda/envs/VIP/lib/python3.8/site-packages/server/common/web/static/interface.html interface.html
    sed '2383 c\
        var tryurls = ['$COMPUTE_DOCKER_PATH_API /interface.html > /tmp_interface.html
    cp /tmp_interface.html /opt/conda/envs/VIP/lib/python3.8/site-packages/server/common/web/static/interface.html

else
    echo 'Starting the run for local'
fi

cellxgene launch --host 0.0.0.0 --port 5005 --disable-annotations --verbose /test-files/file.h5ad


# /opt/conda/bin/python ./polly_script.py
# echo "python executed"

# python3 app.py
# echo $(ls;echo "";sleep 15; /etc/init.d/nginx start;echo "";ls) & supervisord -c /etc/supervisor.con
# OPEN_APP_ID="https://compute.polly.elucidata.io/shiny/app_direct/3931a38ff367832c23d8c07aeea72a44/elucidata/4cpu8gbram3-6-2r/rnaseq_downstream_shiny/?_state_id_=&run_id=65942&parent_id=1685421500726&env=prod&run-id=65942&workspace-id=8020&workspaceId=8020"


# IFS='?' read -ra parts <<< "$OPEN_APP_ID"
# COMPUTE_DOCKER_PATH="${parts[0]}"
# NGINX_CONF="/etc/nginx/sites-available/cellxgene"

# # Generate the nginx configuration file
# cat << EOF > "$NGINX_CONF"
# server {
#     listen 5005;
    
#     location / {
#         rewrite ^/$ / redirect;
#     }

# }
# EOF

# rm /etc/nginx/sites-enabled/default

# ln -s /etc/nginx/sites-available/cellxgene /etc/nginx/sites-enabled

# service nginx restart
# nginx -t



# X=2380
# Y=2390
# < /tmp_interface.html head -n "$Y" | tail -n +"$X"