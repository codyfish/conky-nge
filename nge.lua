require 'cairo'

--http://lua-users.org/wiki/CommonFunctions
function trim(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function conky_main ()

    if conky_window == nil then
	return
    end
    local cs = cairo_xlib_surface_create ( conky_window.display,conky_window.drawable, conky_window.visual, conky_window.width,conky_window.height)
    cr = cairo_create (cs)

    --local updates = tonumber (conky_parse ('${updates}'))
    --if updates > 5 then
    --    print ("hello world")
    --end
    
    cpu = conky_parse ("${cpu}")
    memory = conky_parse ("${memperc}")
    home_used = conky_parse ("${fs_used_perc /home}")
    root_used = conky_parse ("${fs_used_perc /}")
    data_used = conky_parse ("${fs_used_perc /home/felix/data}")
    

    --print("cpu")
    --print(cpu)
    --print(memory)
    --print(home_used)
    --print(root_used)
    --print(data_used)
    

    local border_table ={
         red = 0,
	 green = 0,
	 blue = 0,
	 alpha = 1,
	 width = 4
    }
    local fill_table ={
         red =1,
	 green = 0,
	 blue = 0,
	 alpha = 1,
    }

    local chart_font_table = {
	red = 0.3,
	green = 0.3,
	blue = 0.3,
	alpha = 1,
	font = "Mono",
	font_size = 12,
	font_slant = CAIRO_FONT_SLANT_NORMAL,
	font_face = CAIRO_FONT_WEIGHT_NORMAL,
    }
    font_table = {
	red = 0.3,
	green = 0.3,
	blue = 0.3,
	alpha = 1,
	font = "InconsolataLGC Nerd Font Mono",
	font_size = 32,
	font_slant = CAIRO_FONT_SLANT_NORMAL,
	font_face = CAIRO_FONT_WEIGHT_NORMAL,
	maxl=10,
    }

     local  logo_table = {
	red = 0.3,
	green = 0.3,
	blue = 0.3,
	alpha = 1,
	font = "InconsolataLGC Nerd Font Mono",
	font_size = 150,
	font_slant = CAIRO_FONT_SLANT_NORMAL,
	font_face = CAIRO_FONT_WEIGHT_NORMAL,
	maxl=10,
    }




    local meter_table = {
   	 red = 0.2,
	 green = 0.2,
	 blue = 0.2,
	 alpha = 0.6,
	 width = 10,
	 angle = 3/2*math.pi,
         dred = 0.8,
	 dgreen = 0.5,
	 dblue = 0.5,
	 dalpha = 0.6,
	 tred = 1,
	 tgreen = 0.5,
	 tblue = 0.0,
	 talpha = 0.7,

	 dwidth = 2,

	 font = chart_font_table
      }

      local time_table= {
	red = 1,
	green = 1,
	blue = 1,
	alpha = 1,
	font = "DSEG7 Classic",
	font_size = 35,
	font_slant = CAIRO_FONT_SLANT_NORMAL,
	font_face = CAIRO_FONT_WEIGHT_NORMAL,
	maxl=7,
	st = {
	red = 1,
	green = 1,
	blue = 1,
	alpha = 1,
	font = "DSEG7 Classic",
	font_size = 16,
	font_slant = CAIRO_FONT_SLANT_NORMAL,
	font_face = CAIRO_FONT_WEIGHT_NORMAL,
	maxl=7,
	}
      }

      local process_table = {

	red = 0.3,
	green = 0.3,
	blue = 0.3,
	alpha = 1,
	font = "Arimo Nerd Font",
	font_size = 40,
	font_slant = CAIRO_FONT_SLANT_NORMAL,
	font_face = CAIRO_FONT_WEIGHT_NORMAL,
	maxl = 7,
	st= {

	red = 0.3,
	green = 0.3,
	blue = 0.3,
	alpha = 1,
	font = "Arimo Nerd Font",
	font_size = 25,
	font_slant = CAIRO_FONT_SLANT_NORMAL,
	font_face = CAIRO_FONT_WEIGHT_NORMAL,
	maxl = 10
      }

      }

      local mpd_table = process_table

      evac = {
	border_table = border_table,
	fill_table = fill_table,
	font_table = font_table,
	hexstartx=250,
	hexstarty=250,
	hexlength = 100,
	hexgap = 1,
	meter_table = meter_table,
	time_table = time_table,
	process_table = process_table,
	mpd_table = mpd_table,
	core_table = process_table
      }
--    print(conky_parse("${battery_time}"))
   

    eva_hexagon(cr,0,0,evac)
    seva_circle_meter(cr,0,1, root_used,"root", 100, evac)
    seva_circle_meter(cr,1,0 , home_used,"home", 100, evac)
    seva_circle_meter(cr,2,1 , data_used,"data", 100, evac)
    eva_time(cr,1,1,evac)
    eva_disk_usage(cr,2,2,evac)
    eva_process(cr,3,0,1,evac)
    eva_process(cr,3,1,2,evac)
    eva_process(cr,4,0,3,evac)
    eva_process(cr,4,1,4,evac)
    eva_process(cr,4,2,5,evac)
    eva_downspeed(cr,1,2,"wlp0s20f0u3",evac)
    eva_text(cr,5,0,"asdf",evac.font_table,evac)
    eva_text(cr,6,4,"",logo_table,evac)

    vouts = conky_parse("${exec pactl list sink-inputs | awk '/application.name = \".+\"/ {print $3}'}")

    lines = {}
    for s in vouts:gmatch("[^\r\n]+") do
    	table.insert(lines, s)
    end

    for i,line in next,lines,nil do
	  vout = string.sub(line,2,-2)
	  print(vout)
	  eva_text(cr,7,i,vout,font_table,evac)
    end



    eva_upspeed(cr,2,3,"wlp0s20f0u3",evac)
    eva_cpu_perc(cr,2,4,evac)
    eva_mem(cr,3,2,evac)
    eva_circle_mem(cr,3,3,evac)
    eva_3line(cr,1,3,"asdf",font_table,"asdf",font_table,"asdf",font_table,evac)
    eva_mpd(cr,5,1,evac)
    eva_temperature(cr,5,2,2,evac)
    eva_core(cr,5,3,0,evac)
    eva_core(cr,4,3,1,evac)
    eva_core(cr,6,0,2,evac)
    eva_core(cr,6,1,3,evac)
    eva_s_time(cr,6,2,evac)
    cairo_destroy (cr)
    cairo_surface_destroy (cs)
    cr = nil

end

-- ###############################################################################################
-- EVA Hexagons
-- ###############################################################################################
-- 
--	< 0,0 >---< 0,1 >---< 0,1 >	
--	  ---< 1,0 >---< 1,1 >---
--	< 2,0 >---< 2,1 >---< 2,2 >
--
-- ##############################################################################################
function eva_hexagon(cr,row,col,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_hexagon(cr,x,y,evac)
end

function seva_circle_meter(cr,row,col,value,name,max_value,evac)
	local x,y = hex_pos(row,col,evac)
	draw_seva_circle_meter(cr,x,y,value,name,max_value,evac)
end

function eva_time(cr,row,col,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_time(cr,x,y,evac)
end

function eva_s_time(cr,row,col,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_s_time(cr,x,y,evac)
end

function eva_disk_usage(cr,row,col,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_disk_usage(cr,x,y,evac)
end

function eva_process(cr,row,col,num,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_process(cr,x,y,num,evac)
end

function eva_text(cr,row,col,text,f,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_text(cr,x,y,text,f,evac)
end

function eva_downspeed(cr,row,col,interface,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_downspeed(cr,x,y,interface,evac)
end

function eva_upspeed(cr,row,col,interface,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_upspeed(cr,x,y,interface,evac)
end

function eva_cpu_perc(cr,row,col,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_cpu_perc(cr,x,y,evac)
end

function eva_mem(cr,row,col,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_mem(cr,x,y,evac)
end

function eva_temperature(cr,row,col,num,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_temperature(cr,x,y,num,evac)
end


function eva_circle_mem(cr,row,col,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_circle_mem(cr,x,y,evac)
end

function eva_2line(cr,row,col,l1,f1,l2,f2,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_2line(cr,x,y,l1,f1,l2,f2,evac)
end

function eva_3line(cr,row,col,l1,f1,l2,f2,l3,f3,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_3line(cr,x,y,l1,f1,l2,f2,l3,f3,evac)
end

function eva_mpd(cr,row,col,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_mpd(cr,x,y,evac)
end

function eva_core(cr,row,col,core,evac)
	local x,y = hex_pos(row,col,evac)
	draw_eva_core(cr,x,y,core,evac)
end
-- ###############################################################################################
--IMPL
-- ###############################################################################################


function hex_pos(row,col,evac)
	
	local x = evac.hexstartx + col*3*evac.hexlength + (row%2)*3/2*evac.hexlength + col*2*evac.hexgap +(row%2)*evac.hexgap
	local y = evac.hexstarty + row*87/100*evac.hexlength + row*evac.hexgap
	return x,y	
end

function draw_eva_hexagon(cr, pos_x, pos_y, evac)
	local et = {
		red = 0,
		green = 0,
		blue = 0,
		alpha = 0,
		width = 0
	}

	draw_hexagon(cr, pos_x, pos_y, evac.hexlength, et, evac.fill_table)
	draw_hexagon(cr, pos_x-2*evac.border_table.width, pos_y, evac.hexlength-2*evac.border_table.width, evac.border_table, et)
end


function draw_hexagon(cr, pos_x, pos_y, length, border_table, fill_table)
	local bt = border_table
	local ft = fill_table
	cairo_set_line_width (cr,bt.width)
        cairo_move_to (cr, pos_x,pos_y)
        cairo_line_to (cr, pos_x-1/2*length,pos_y-87/100*length)
        cairo_line_to (cr, pos_x-3/2*length,pos_y-87/100*length)
        cairo_line_to (cr, pos_x-2*length,pos_y)
        cairo_line_to (cr, pos_x-3/2*length,pos_y+87/100*length)
        cairo_line_to (cr, pos_x-1/2*length,pos_y+87/100*length)
        cairo_close_path (cr)
	cairo_set_source_rgba(cr,ft.red,ft.green,ft.blue,ft.alpha)
	cairo_fill_preserve(cr)
	cairo_set_source_rgba(cr,bt.red,bt.green,bt.blue,bt.alpha)
        cairo_stroke (cr)
end


function draw_center_text(cr,cx,cy,text,ft)
	-- https://stackoverflow.com/questions/42671518/cairo-text-extents-t-is-not-recognized-by-lua
	-- https://www.cairographics.org/samples/text_align_center/

	if string.len(text)>ft.maxl then
		text = string.sub(text,0,ft.maxl)
	end

	local ext = cairo_text_extents_t:create()
	tolua.takeownership(ext)

	cairo_select_font_face(cr,ft.font,ft.font_slant,ft.font_face)
	cairo_set_font_size(cr,ft.font_size)
	cairo_set_source_rgba(cr,ft.red,ft.green,ft.blue,ft.alpha)

	cairo_text_extents(cr, text, ext)
	cairo_move_to(cr,cx-(ext.width / 2 + ext.x_bearing),cy-(ext.height/2+ext.y_bearing))
	cairo_show_text(cr,text)
	cairo_stroke(cr)
end

function draw_2c_text(cr,cx,cy,s1,f1,s2,f2)
	if string.len(s1)>f1.maxl then
		s1 = string.sub(s1,0,f1.maxl)
	end
	if string.len(s2)>f2.maxl then
		s2 = string.sub(text,0,f2.maxl)
	end

	local ext1 = cairo_text_extents_t:create()
	tolua.takeownership(ext1)

	cairo_select_font_face(cr,f1.font,f1.font_slant,f1.font_face)
	cairo_set_font_size(cr,f1.font_size)

	cairo_text_extents(cr, s1, ext1)
	
	local ext2 = cairo_text_extents_t:create()
	tolua.takeownership(ext2)

	cairo_select_font_face(cr,f2.font,f2.font_slant,f2.font_face)
	cairo_set_font_size(cr,f2.font_size)
	cairo_set_source_rgba(cr,f2.red,f2.green,f2.blue,f2.alpha)

	cairo_text_extents(cr, s2, ext2)
	
	local dy = 0
	if(ext1.height > ext2.height) then
		dy = ext1.height/2+ext1.y_bearing
	else 
		dy = ext2.height/2+ext2.y_bearing
	end

	x1 = cx - (ext1.width+ext2.width)/2 - ext1.x_bearing
	x2 = x1 + ext1.x_bearing +ext1.width

	cairo_move_to(cr,x2,cy-dy)
	cairo_show_text(cr,s2)

	cairo_select_font_face(cr,f1.font,f1.font_slant,f1.font_face)
	cairo_set_font_size(cr,f1.font_size)
	cairo_set_source_rgba(cr,f1.red,f1.green,f1.blue,f1.alpha)

	cairo_move_to(cr,x1,cy-dy)
	cairo_show_text(cr,s1)
	cairo_stroke(cr)
end

function circle_meter (cr, value, name,pos_x,pos_y,radius,max_value, meter_table)
	local mt = meter_table
	cairo_set_line_width (cr, mt.width)
	cairo_set_line_cap (cr, CAIRO_LINE_CAP_BUTT)
	cairo_set_source_rgba (cr, mt.dred, mt.dgreen, mt.dblue,mt.dalpha)
	cairo_arc(cr,pos_x,pos_y,radius,math.pi/2,meter_table.angle+math.pi/2)
	cairo_stroke(cr)

        local end_angle = math.max(0,value/max_value*meter_table.angle-0.1)
        --print (end_angle)
	--bar
        cairo_set_source_rgba (cr, mt.red, mt.green, mt.blue,mt.alpha)
        cairo_arc (cr, pos_x, pos_y, radius,math.pi/2, end_angle+math.pi/2)
        cairo_stroke (cr)
        --tip
	cairo_set_source_rgba (cr, mt.tred, mt.tgreen, mt.tblue,mt.talpha)
        cairo_arc (cr, pos_x, pos_y, radius,end_angle+math.pi/2, end_angle+math.pi/2+0.1)
        cairo_stroke (cr)

	-- draw delimeter
	cairo_set_line_width (cr, mt.dwidth)
	cairo_set_line_cap (cr, CAIRO_LINE_CAP_ROUND)
        cairo_set_source_rgba (cr, mt.dred, mt.dgreen, mt.dblue,mt.dalpha)
        cairo_move_to(cr,pos_x,pos_y)
	cairo_rel_line_to(cr,0,radius*1.2)
	cairo_stroke(cr)

	-- draw text
	cairo_select_font_face(cr,mt.font.font,mt.font.font_slant,mt.font.font_face)
	cairo_set_font_size(cr,mt.font.font_size)
	cairo_set_source_rgba(cr,mt.font.red,mt.font.green,mt.font.blue,mt.font.alpha)
	cairo_move_to(cr,pos_x+mt.width/2,pos_y+radius+mt.width/2)
	cairo_show_text(cr, name)
	cairo_stroke(cr)
end

-- simple circle meter
function draw_seva_circle_meter(cr,pos_x,pos_y,value,name, max_value, evac)
	draw_eva_hexagon(cr,pos_x,pos_y,evac)
	-- center of circle
	local cx = pos_x - evac.hexlength
	local cy = pos_y
	local radius = evac.hexlength/2

	circle_meter(cr, value, name, cx,cy,radius,max_value,evac.meter_table)
	
end

-- disk usage of several partitions in one hexagone
function draw_eva_disk_usage(cr, pos_x,pos_y,evac)
	draw_eva_hexagon(cr,pos_x,pos_y,evac)
	-- center of circle
	local cx = pos_x - evac.hexlength
	local cy = pos_y
	local radius = evac.hexlength/2
	
	local home_used = conky_parse ("${fs_used_perc /home}")
  	local root_used = conky_parse ("${fs_used_perc /}")
  	local data_used = conky_parse ("${fs_used_perc /home/felix/data}")

	local r_div = evac.meter_table.width+evac.border_table.width

	circle_meter(cr, home_used, "home", cx,cy,radius-r_div,100,evac.meter_table)
	circle_meter(cr, root_used, "root", cx,cy,radius-2*r_div,100,evac.meter_table)
	circle_meter(cr, data_used, "data", cx,cy,radius,100,evac.meter_table)
	
end

function draw_eva_time(cr, pos_x, pos_y, evac)
	local tt = evac.time_table
	draw_eva_hexagon(cr,pos_x,pos_y,evac)
	local time = conky_parse("${time %H:%M}")
	--print(time)
	draw_center_text(cr,pos_x-evac.hexlength,pos_y,time,tt)
end

function draw_eva_s_time(cr,pos_x,pos_y,evac)
	local tt = evac.time_table
	draw_eva_hexagon(cr,pos_x,pos_y,evac)
	local t1 = conky_parse("${time %H:%M}")
	local t2 = conky_parse("${time :%S}")
	draw_2c_text(cr,pos_x-evac.hexlength,pos_y,t1,tt,t2,tt.st)
end

function draw_eva_process(cr, pos_x,pos_y,num, evac)
	local pt = evac.process_table
 	local name = conky_parse("${top name "..num.."}")
 	local cpu = conky_parse("${top cpu "..num.."}")
 	local mem = conky_parse("${top mem "..num.."}")
	
	draw_eva_3line(cr,pos_x,pos_y," " ..trim(cpu) .. "%",pt.st,name,pt," " .. trim(mem) .. "%",pt.st,evac)
end

function draw_eva_text(cr,pos_x,pos_y,string,ft,evac)
	draw_eva_hexagon(cr,pos_x,pos_y,evac)
	
	draw_center_text(cr,pos_x-evac.hexlength,pos_y,string,ft)

end

function draw_eva_2line(cr,pos_x,pos_y,l1,f1,l2,f2,evac)

	draw_eva_hexagon(cr,pos_x,pos_y,evac)

	draw_center_text(cr,pos_x-evac.hexlength,pos_y-f1.font_size/3*2,l1,f1)
	draw_center_text(cr,pos_x-evac.hexlength,pos_y+f2.font_size/3*2,l2,f2)
end

function draw_eva_3line(cr,pos_x,pos_y,l1,f1,l2,f2,l3,f3,evac)
	draw_eva_hexagon(cr,pos_x,pos_y,evac)

	local cx = pos_x - evac.hexlength

	draw_center_text(cr,cx,pos_y-f2.font_size,l1,f1)
	draw_center_text(cr,cx,pos_y,l2,f2)
	draw_center_text(cr,cx,pos_y+f2.font_size,l3,f3)

end

function draw_eva_downspeed(cr,pos_x,pos_y,interface,evac)
	local dspeed = conky_parse( "${downspeed ".. interface .."}")
	local symbol = ""

	draw_eva_2line(cr,pos_x,pos_y,symbol,evac.font_table,dspeed,evac.font_table,evac)
end

function draw_eva_upspeed(cr,pos_x,pos_y,interface,evac)
	local dspeed = conky_parse( "${upspeed ".. interface .."}")
	local symbol = ""

	draw_eva_2line(cr,pos_x,pos_y,symbol,evac.font_table,dspeed,evac.font_table,evac)
end

function draw_eva_cpu_perc(cr,pos_x,pos_y,evac)
	local cpu = conky_parse("${cpu cpu0}") .."%"
	local symbol = ""

	draw_eva_2line(cr,pos_x,pos_y,symbol,evac.font_table,cpu,evac.font_table,evac)
end

function draw_eva_mem(cr,pos_x,pos_y,evac)
	local mem = conky_parse("${mem}")
	local symbol = ""

	draw_eva_2line(cr,pos_x,pos_y,symbol,evac.font_table,mem,evac.font_table,evac)
end

function draw_eva_temperature(cr,pos_x,pos_y,num,evac)
	local temp = conky_parse("${platform coretemp.0/hwmon/hwmon2 temp "..num.."}") .. "°C"
	local symbol = "Core "..(num-2)

	draw_eva_2line(cr,pos_x,pos_y,symbol,evac.font_table,temp,evac.font_table,evac)
end

function draw_eva_circle_mem(cr,pos_x,pos_y,evac)
	local memperc = conky_parse("${memperc}")
	local swapperc = conky_parse("${swapperc}")

	draw_eva_hexagon(cr,pos_x,pos_y,evac)

	local cx = pos_x - evac.hexlength
	local cy = pos_y
	local radius = evac.hexlength/2
	

	local r_div = evac.meter_table.width+evac.border_table.width

	circle_meter(cr, swapperc, "swap", cx,cy,radius-r_div,100,evac.meter_table)
	circle_meter(cr, memperc, "mem", cx,cy,radius,100,evac.meter_table)
end

function draw_eva_mpd(cr,pos_x,pos_y,evac)

	local mt = evac.mpd_table
	local title = conky_parse("${mpd_title}")
	local artist = conky_parse("${mpd_artist}")
	local album = conky_parse("${mpd_album}")

	draw_eva_3line(cr,pos_x,pos_y,artist,mt.st,title,mt,album,mt.st,evac)
end

function draw_eva_core(cr,pos_x,pos_y,core,evac)
	local ft = evac.core_table
	local freq = conky_parse("${freq_g " .. (core+1).."}GHz")
	local temp = conky_parse("${platform coretemp.0/hwmon/hwmon2 temp "..(core+2).."}°C")

	draw_eva_3line(cr,pos_x,pos_y,freq,ft.st,"Core "..core,ft,temp,ft.st,evac)
end

