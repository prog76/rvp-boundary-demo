export AUTH_METHODS_JSON=$(boundary auth-methods list -recursive -format=json)
export OIDC_AUTH_ID=$(echo $AUTH_METHODS_JSON | jq -r '.items[] | select(.type == "oidc") | .id')
export PASSWORD_AUTH_ID=$(echo $AUTH_METHODS_JSON | jq -r '.items[] | select(.type == "password") | .id')
export BOUNDARY_TOKEN=$(boundary authenticate password -auth-method-id=$PASSWORD_AUTH_ID -login-name=$BOUNDARY_LOGIN -password=env://BOUNDARY_PASS -keyring-type=none -format=json | jq -r '.item.attributes.token')

function boundary_targets() {
    local pattern="$1"

    boundary targets list -recursive -format json | \
        jq --arg pattern "$pattern" '.items[] | select(.description | test($pattern)) | {Name: .name, Description: .description, ID: .id}'
}

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}List available resources with:${NC}"
echo -e " ${GREEN}boundary_targets SSH${NC}"
echo -e " ${GREEN}boundary_targets SQL${NC}"

echo -e "${YELLOW}Connect them with:${NC}"
echo -e " ${GREEN}boundary connect ssh -target-id [target_id]${NC}"
echo -e " ${GREEN}boundary connect postgres -username=root -dbname=root -target-id [target_id]${NC}"
echo -e " ${GREEN}echo "select 1+1" | boundary connect -exec psql -target-id [target_id] -- postgresql://root:changeme@{{boundary.ip}}:{{boundary.port}}/root${NC}"

echo -e "${YELLOW}Invoke OIDC authentication with this:${NC}"
echo -e " ${GREEN}export BOUNDARY_TOKEN=\$(boundary authenticate oidc -auth-method-id=\$OIDC_AUTH_ID -keyring-type=none -format=json | jq -r \".item.attributes.token\")${NC}"
