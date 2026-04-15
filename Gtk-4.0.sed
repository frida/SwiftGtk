s/gtk_popover_bin_set_popover(\([^,]*\), \([^)]*\)\.popover_ptr)/gtk_popover_bin_set_popover(\1, \2.widget_ptr)/g
s/class TreeIter:/class TreeIterBase:/
s/Id/ID/g
s/IDle/Idle/g
s/IDent/Ident/g
