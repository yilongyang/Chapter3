#test python
import dendropy
import re
with open("tree-list.txt",'r') as f:
	data=f.read()
my_list=data.splitlines()
#f=open('marker-rooted-nwk.txt', 'w')
for line in my_list:
	#print line
	#print 'Yilong'
	tree = dendropy.Tree.get(
    path=line,
    schema="nexus",
    )
	treestr=tree.as_string(schema='newick')
	#print treestr
	matcha=re.search(r'(Potent.*?)\'',treestr)
	matchb=re.search(r'(FRA1358.*?)\'',treestr)
	matchc=re.search(r'(FRA202.*?)\'',treestr)
	matchd=re.search(r'(GS.*?)\'',treestr)
	if matcha:
		print matcha.group(1)
		root=matcha.group(1)
	elif matchb:
		print matchb.group(1)
		root=matchb.group(1)
	elif matchc:
		print matchc.group(1)
		root=matchc.group(1)
	elif matchd:
		print matchd.group(1)
		root=matchd.group(1)
	node_D = tree.find_node_with_taxon_label(root)
	tree.reroot_at_edge(node_D.edge, update_bipartitions=False)
	#print("After:")
	print(tree.as_string(schema='newick'))
	#rootedstr=tree.as_string(schema='newick')
	#f.write(rootedstr)
	print(tree.as_ascii_plot())
	#break