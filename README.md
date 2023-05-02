# mumudvb-conf-turkey
sample mumudvb config files for turksat &amp; hotbird

# Usage with MumuDVB

I have a TBS5530 and I can capture whole TS of a transponder with following command:

```bash
mumudvb -dt -c 11053h8000-st.conf --dumpfile somedir/new6.ts
```

Valid config files are in respective directories sorted in Satellite names

## Some notes

Notice the difference between 11053h8000-st.conf and 11053h8000-braice.conf

Both can lock to signal and capture data.

Important note: on all conf files, I disabled multicast streaming, it was causing frame drops for my case. This is just for capturing whole TS.

