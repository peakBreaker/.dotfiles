#!/usr/bin/env bash 

WKNAME=$1
echo workspace name given is $WKNAME
if i3-msg -t get_workspaces | jq ".[] | .name" | grep -q -w $WKNAME; then
  i3-msg "workspace $WKNAME"
else
  i3-msg "workspace $WKNAME; append_layout ~/.scripts/.i3empty/empty_layout.json"
fi
