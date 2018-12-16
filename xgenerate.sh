#!/usr/bin/env bash

# set -x

cat << "EOF"
   _____   ____  ______________                         .__             __
  /  _  \  \   \/  /\__    ___/  ____    _____  ______  |  |  _____   _/  |_   ____
 /  /_\  \  \     /   |    |   _/ __ \  /     \ \____ \ |  |  \__  \  \   __\_/ __ \
/    |    \ /     \   |    |   \  ___/ |  Y Y  \|  |_> >|  |__ / __ \_ |  |  \  ___/
\____|__  //___/\  \  |____|    \___  >|__|_|  /|   __/ |____/(____  / |__|   \___  >
        \/       \_/                \/       \/ |__|               \/             \/
=====================================================================================

EOF

which mint >> /dev/null
if [ $(echo $?) == 1 ]; then
    echo "Please install mint and run this script again"
    echo "https://github.com/yonaskolb/Mint"
    echo "> brew install mint"
    exit 1
fi

DATE=$(date +'%d/%m/%Y')
YEAR=$(date +'%Y')
rm ./PROJECT_YML &> /dev/null
rm ./PROJECT_YML_TMP &> /dev/null

read -p 'Product Name: ' PRODUCT_NAME
if [ -z "$PRODUCT_NAME" ]; then
    echo 'Product name cannot be empty'
    exit 1
fi

GIT_AUTHOR=$(git config user.name)
read -e -p "Developer Name: " -i "${GIT_AUTHOR}" AUTHOR
if [ -z "$AUTHOR" ]; then
    AUTHOR=$GIT_AUTHOR
fi

read -e -p "Organization Name: " -i "Area51" ORGNAME
if [ -z "$ORGNAME" ]; then
    echo 'Organization name cannot be empty'
    exit 1
fi

read -e -p "Organization identifier: " -i "io.area51" ORGID
if [[ $ORGID =~ ^([A-Za-z0-9_]+)(.([A-Za-z0-9_]+))*$ ]]; then
    echo
else
    echo 'Invalid organization identifier'
    exit 1
fi

PRODID="$(echo -e "${PRODUCT_NAME}" | tr -d '[:space:]')"

TARGET_VERSIONS="12.1 12.0 11.4 11.3 11.2 11.1 11.0 10.3 10.2 10.1 10.1 10.0 9.3 9.2 9.1 9.0"
echo 'Deployment Target:'
select DEPLYMENT_TARGET in $TARGET_VERSIONS; do
    if [ ! -z "$DEPLYMENT_TARGET" ]; then
    echo; break
    fi
done

cat >> PROJECT_YML << EOM
name: ${PRODID}
groupSortPosition: top
configFiles:
  Debug: xcconfigs/Debug.xcconfig
  Release: xcconfigs/Release.xcconfig
targets:
  $PRODID:
    type: application
    platform: iOS
    deploymentTarget: "${DEPLYMENT_TARGET}"
    sources: [${PRODID}]
    configFiles:
        Debug: xcconfigs/${PRODID}-Debug.xcconfig
        Release: xcconfigs/${PRODID}-Release.xcconfig
    dependencies: []
EOM

echo 'Include Unit Tests:'
select UNIT_TESTS in Yes No; do
    if [ ! -z "$UNIT_TESTS" ]; then
    echo; break
    fi
done

if [ "$UNIT_TESTS" == "Yes" ]; then
cat >> PROJECT_YML_TMP << EOM
  ${PRODID}Tests:
    type: bundle.unit-test
    platform: iOS
    sources: [${PRODID}Tests]
    configFiles:
        Debug: xcconfigs/${PRODID}Tests-Debug.xcconfig
        Release: xcconfigs/${PRODID}Tests-Release.xcconfig
    dependencies:
      - target: ${PRODID}
EOM
cat ./PROJECT_YML_TMP >> ./PROJECT_YML
rm ./PROJECT_YML_TMP &> /dev/null
fi

echo 'Include UI Tests:'
select UI_TESTS in Yes No; do
    if [ ! -z "$UI_TESTS" ]; then
    echo; break
    fi
done

if [ "$UI_TESTS" == "Yes" ]; then
cat >> PROJECT_YML_TMP << EOM
  ${PRODID}UITests:
    type: bundle.ui-testing
    platform: iOS
    sources: [${PRODID}UITests]
    configFiles:
        Debug: xcconfigs/${PRODID}UITests-Debug.xcconfig
        Release: xcconfigs/${PRODID}UITests-Release.xcconfig
    dependencies:
      - target: ${PRODID}
EOM
cat ./PROJECT_YML_TMP >> ./PROJECT_YML
rm ./PROJECT_YML_TMP &> /dev/null
fi

echo
echo -- begin: project.yml --
cat ./PROJECT_YML
echo -- end: project.yml --
echo

echo 'Proceed with this config?'
select PROCEED in Yes No; do
    if [ ! "$PROCEED" == "Yes" ]; then
        exit 1
    else
        echo; break
    fi
done

set -e

mv ./PROJECT_YML project.yml
mv ./Template ./${PRODID}
mv ./TemplateTests ./"${PRODID}Tests"
mv ./TemplateUITests ./"${PRODID}UITests"

rename "s/(Template)(.*)$/${PRODID}\$2/" ./xcconfigs/*

sed -i -e "s/Template.xcconfig/${PRODID}.xcconfig/g" ./xcconfigs/*
sed -i -e "s/TemplateTests.xcconfig/${PRODID}Tests.xcconfig/g" ./xcconfigs/*
sed -i -e "s/TemplateUITests.xcconfig/${PRODID}UITests.xcconfig/g" ./xcconfigs/*

sed -i -e "s/Template\/SupportFiles\/Info.plist/${PRODID}\/SupportFiles\/Info.plist/g" ./xcconfigs/*
sed -i -e "s/TemplateTests\/SupportFiles\/Info.plist/${PRODID}Tests\/SupportFiles\/Info.plist/g" ./xcconfigs/*
sed -i -e "s/TemplateUITests\/SupportFiles\/Info.plist/${PRODID}UITests\/SupportFiles\/Info.plist/g" ./xcconfigs/*

sed -i -e "s/TEST_TARGET_NAME = Template/TEST_TARGET_NAME = ${PRODID}/g" ./xcconfigs/*

sed -i -e "s/io.generic.Template/${ORGID}.${PRODID}/g" ./xcconfigs/*
sed -i -e "s/Template.app\/Template/${PRODID}.app\/${PRODID}/g" ./xcconfigs/*

find ./"${PRODID}" -type f -name "*.swift" \
    -exec sed -i -e "s/\/\/  Template/\/\/  ${PRODID}/g" {} \;

find ./"${PRODID}Tests" -type f -name "*.swift" \
    -exec sed -i -e "s/\/\/  TemplateTests/\/\/  ${PRODID}Tests/g" {} \;

find ./"${PRODID}UITests" -type f -name "*.swift" \
    -exec sed -i -e "s/\/\/  TemplateUITests/\/\/  ${PRODID}UITests/g" {} \;

find ./"${PRODID}"* -type f -name "*.swift" \
    -exec sed -i -e "s#AUTHOR on DATE#${AUTHOR} on ${DATE}#g" {} \;

find ./"${PRODID}"* -type f -name "*.swift" \
    -exec sed -i -e "s/2018 ORGNAME/${YEAR} ${ORGNAME}/g" {} \;

cat >> generate.sh << EOF
mint run yonaskolb/xcodegen
EOF

chmod 744 ./generate.sh

rm -- $0
rm -rf .git
rm README.md

NEWLINE=$'\n'
FINAL_MSG="Project ${PRODUCT_NAME} created.${NEWLINE}\
Use ./generate.sh to regenerate the .xcodeproj${NEWLINE}"

echo 'Initialize git repository?'
select USE_GIT in Yes No; do
    if [ ! "$USE_GIT" == "Yes" ]; then
        echo $FINAL_MSG
        exit 0
    else
        echo; break
    fi
done

read -p 'Commit message (Initial commit): ' COMMIT_MSG
if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Initial commit"
fi

git init .
git add .
git commit -m "$COMMIT_MSG"
git clean -df
git checkout .

echo "${NEWLINE}====================================================================================="
echo "$FINAL_MSG"
exit 0
