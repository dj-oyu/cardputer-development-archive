import bpy,json,pathlib,sys
out=pathlib.Path(sys.argv[sys.argv.index('--')+1])
def layer(c):return {'name':c.name,'exclude':c.exclude,'hide_viewport':c.hide_viewport,'children':[layer(x) for x in c.children]}
x={'objects':[{'name':o.name,'type':o.type,'hide_render':o.hide_render,'hide_viewport':o.hide_viewport,'collections':[c.name for c in o.users_collection]} for o in bpy.data.objects],'collections':[{'name':c.name,'hide_render':c.hide_render,'hide_viewport':c.hide_viewport,'hide_select':c.hide_select,'objects':len(c.objects)} for c in bpy.data.collections],'view_layers':[{'name':v.name,'root':layer(v.layer_collection)} for v in bpy.context.scene.view_layers],'note':'Raw flags only; not evaluated visibility or active frame geometry.'}
with out.open('x') as f:json.dump(x,f,indent=2)
