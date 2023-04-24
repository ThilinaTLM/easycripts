#!/bin/sh

current_scale = $(kscreen-doctor -j | jq -r '.outputs[0].scale')
kscreen-doctor "output.Chimei Innolux Corporation eDP-1-unknown.scale.82e-2"
