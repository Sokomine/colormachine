
--[[
    color chooser for unifieddyes

    Copyright (C) 2013 Sokomine

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]


colormachine = {};

colormachine.colors = {
        "red",
        "orange",
        "yellow",
        "lime",
        "green",
        "aqua",
        "cyan",
        "skyblue",
        "blue",
        "violet",
        "magenta",
        "redviolet"
}


-- the names of suitable sources of that color (note: this does not work by group!);
-- you can add your own color sources here if you want
colormachine.basic_dye_sources  = { "flowers:rose",      "flowers:tulip",         "flowers:dandelion_yellow", 
                                    "default:cactus",    "flowers:geranium",      "flowers:viola",
                                    "default:coal_lump", "flowers:dandelion_white" };

-- if flowers is not installed
colormachine.alternate_basic_dye_sources  = { 
                                    "default:apple",     "default:desert_stone",  "default:sand",  
                                    "default:cactus",    "default:leaves",        "default:dry_shrub",
                                    "default:coal_lump", "default:stone" };


-- the machine will store these basic dyes which can be obtained from flowers
colormachine.basic_dye_names    = { "red", "orange", "yellow", "green", "blue", "violet", "black", "white"};

-- construct the formspec for the color selector
colormachine.prefixes     = { 'light_', '', 'medium_', 'dark_' };

-- grey colors are named slightly different
colormachine.grey_names   = { 'white', 'lightgrey', 'grey', 'darkgrey', 'black' };

-- defines the order in which blocks are shown
--   nr:          the diffrent block types need to be ordered by some system; the number defines that order
--   modname:     some mods define more than one type of colored blocks; the modname is needed 
--                for checking if the mod is installed and for creating colored blocks
--   shades:      some mods (or parts thereof) do not support all possible shades
--   grey_shades: some mods support only some shades of grey (or none at all)
--   u:           if set to 1, use full unifieddyes-colors; if set to 0, use only normal dye/wool colors
--   descr:       short description of nodes of that type for the main menu
--   block:       unpainted basic block
--   add:         item names are formed by <modname>:<add><colorname> (with colorname beeing variable)
--                names for the textures are formed by <index><colorname><png> mostly (see colormachine.translate_color_name(..))

colormachine.data = {
-- the dyes as such
   unifieddyes_              = { nr=1,  modname='unifieddyes',   shades={1,0,1,1,1,1,1,1}, grey_shades={1,1,1,1,1}, u=1, descr="ufdye",  block="dye:white", add="" },

-- coloredwood: sticks not supported (they are only craftitems)
   coloredwood_wood_         = { nr=2,  modname='coloredwood',   shades={1,0,1,1,1,1,1,1}, grey_shades={1,1,1,1,1}, u=1, descr="planks", block="default:wood", add="wood_"  },
   coloredwood_fence_        = { nr=3,  modname='coloredwood',   shades={1,0,1,1,1,1,1,1}, grey_shades={1,1,1,1,1}, u=1, descr="fence",  block="default:fence_wood", add="fence_" },

-- unifiedbricks: clay lumps and bricks not supported (they are only craftitems)
   unifiedbricks_clayblock_  = { nr=4,  modname='unifiedbricks', shades={1,0,1,1,1,1,1,1}, grey_shades={1,1,1,1,1}, u=1, descr="clay",   block="default:clay",  add="clayblock_" },
   unifiedbricks_brickblock_ = { nr=5,  modname='unifiedbricks', shades={1,0,1,1,1,1,1,1}, grey_shades={1,1,1,1,1}, u=1, descr="brick",  block="default:brick", add="brickblock_"},
   -- the multicolored bricks come in fewer intensities (only 3 shades) and support only 3 insted of 5 shades of grey
   unifiedbricks_multicolor_ = { nr=6,  modname='unifiedbricks', shades={1,0,0,0,1,0,1,0}, grey_shades={0,1,1,1,0}, u=1, descr="mbrick", block="default:brick", add="multicolor_"},

-- stained_glass: has a "faint" and "pastel" version as well (which are kind of additional shades used only by this mod)
   -- no shades of grey for the glass
   stained_glass_            = { nr=7,  modname='stained_glass', shades={1,0,1,1,1,1,1,1}, grey_shades={0,0,0,0,0}, u=1, descr="glass",  block="moreblocks:superglowglass", add="" },
   stained_glass_faint_      = { nr=8,  modname='stained_glass', shades={0,0,1,0,0,0,0,0}, grey_shades={0,0,0,0,0}, u=1, descr="fglass", block="moreblocks:superglowglass", add="" },
   stained_glass_pastel_     = { nr=9,  modname='stained_glass', shades={0,0,1,0,0,0,0,0}, grey_shades={0,0,0,0,0}, u=1, descr="pglass", block="moreblocks:superglowglass", add="" },

-- cotton:
   cotton_                   = { nr=10, modname='cotton',        shades={1,0,1,1,1,1,1,1}, grey_shades={1,1,1,1,1}, u=1, descr="cotton", block="cotton:white",   add=""  },

-- normal wool (from minetest_gmae) - does not support all colors from unifieddyes
   wool_                     = { nr=11, modname='wool',          shades={1,0,1,0,0,0,1,0}, grey_shades={1,0,1,1,1}, u=0, descr="wool",   block="wool:white",     add=""  },

-- normal dye mod (from minetest_game) - supports as many colors as the wool mod
   dye_                      = { nr=12, modname='dye',           shades={1,0,1,0,0,0,1,0}, grey_shades={1,0,1,1,1}, u=0, descr="dye",    block="dye:white",      add=""  },

   beds_bed_top_top_         = { nr=13, modname='beds',          shades={0,0,1,0,0,0,0,0}, grey_shades={1,0,1,0,1}, u=0, descr="beds",   block="beds:bed_white", add="bed_" },

   lrfurn_armchair_front_    = { nr=14, modname='lrfurn',        shades={0,0,1,0,0,0,0,0}, grey_shades={1,0,1,0,1}, u=0, descr="armchair",block="lrfurn:armchair_white", add="armchair_" },
   lrfurn_sofa_right_front_  = { nr=15, modname='lrfurn',        shades={0,0,1,0,0,0,0,0}, grey_shades={1,0,1,0,1}, u=0, descr="sofa",    block="lrfurn:longsofa_white", add="sofa_" },
   lrfurn_longsofa_middle_front_= { nr=16, modname='lrfurn',     shades={0,0,1,0,0,0,0,0}, grey_shades={1,0,1,0,1}, u=0, descr="longsofa",block="lrfurn:sofa_white", add="longsofa_" },

   -- grey variants do not seem to exist, even though the textures arethere (perhaps nobody wants a grey flag!)
   flags_                    = { nr=17, modname='flags',         shades={0,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=1, descr="flags",   block="flags:white", add="" },

   blox_stone_               = { nr=18, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="SnBlox",  block="default:stone", add="stone" },
   blox_quarter_             = { nr=19, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="S4Blox",  block="default:stone", add="quarter" },
   blox_checker_             = { nr=20, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="S8Blox",  block="default:stone", add="checker" },
   blox_diamond_             = { nr=21, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="SDBlox",  block="default:stone", add="diamond"},
   blox_cross_               = { nr=22, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="SXBlox",  block="default:stone", add="cross" },
   blox_square_              = { nr=23, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="SQBlox",  block="default:stone", add="square" },
   blox_loop_                = { nr=24, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="SLBlox",  block="default:stone", add="loop" },
   blox_corner_              = { nr=25, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="SCBlox",  block="default:stone", add="corner" },

   blox_wood_                = { nr=26, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="WnBlox",  block="default:wood", add="wood" },
   blox_quarter_wood_        = { nr=27, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="W4Blox",  block="default:wood", add="quarter_wood" },
   blox_checker_wood_        = { nr=28, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="W8Blox",  block="default:wood", add="checker_wood"},
   blox_diamond_wood_        = { nr=29, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="WDBlox",  block="default:wood", add="diamond_wood"},

   blox_cobble_              = { nr=30, modname='blox',          shades={1,0,1,0,0,0,0,0}, grey_shades={1,0,0,0,1}, u=0, descr="CnBlox",  block="default:cobble", add="cobble" },

   homedecor_window_shutter_ = { nr=31, modname='homedecor',     shades={1,0,1,0,0,0,1,0}, grey_shades={1,0,1,1,1}, u=0, descr="homedec", block="homedecor:shutter_oak", add="shutter_"},

}


colormachine.ordered = {}


-- the function that creates the color chooser based on the textures of the nodes offered (texture names have to start with m_prefix)
colormachine.generate_form = function( m_prefix )

   local form = "size["..tostring( #colormachine.colors+2 )..",10]".."label[5,0;Select a color:]"..
         "label[5,8.2;Select a color or]"..
         "button[7,8.2;2,1;abort;abort selection]"..
         "label[0.3,1;light]";

   -- not all mods offer all shades (and some offer even more)
   local supported = colormachine.data[ m_prefix ].shades; 

   if( supported[2]==0 ) then
      form = form..
         "label[0.3,2;normal]"..
         "label[0.3,4;medium]"..
         "label[0.3,6;dark]";
   else
      form = form..
         "label[0.3,3;normal]"..
         "label[0.3,5;medium]"..
         "label[0.3,7;dark]";
   end

   for x,basecolor in ipairs( colormachine.colors ) do
      local p_offset = 1;

      form = form.."label["..tostring(x)..",0.5;"..tostring( basecolor ).."]";


      for y,pre in ipairs( colormachine.prefixes ) do

         local translated_color = colormachine.translate_color_name( nil, m_prefix, tostring( pre )..tostring( basecolor ), x, y*2-1, -1, 0 );
         -- normal dye and wool need a nasty further exception here - they only offer one dark color: green...
         if( supported[ y * 2-1 ]==1
             and translated_color ~= nil ) then -- special treatment of normal dyes/wool

            form = form.."image_button["..tostring(x)..","..tostring(p_offset)..";1,1;"..
                                          translated_color..";"..
                                          tostring( pre )..tostring( basecolor ).."; ]";
         end
         p_offset = p_offset + 1;

         -- these only exist in unifieddyes and need no translation
         if( supported[ y * 2   ]==1 ) then
            form = form.."image_button["..tostring(x)..","..tostring(p_offset)..";1,1;"..m_prefix..
                                          tostring( pre )..tostring( basecolor ).."_s50.png;"..
                                          tostring( pre )..tostring( basecolor ).."_s50; ]";
         end

         -- the first row does not always hold all colors
         if( y >1 or supported[ y * 2   ]==1) then
            p_offset = p_offset + 1;
         end
      end
   end

   -- shades of grey
   form = form.. "label["       ..tostring( #colormachine.colors+1 )..",0.5;grey]";
   for i,gname in ipairs( colormachine.grey_names ) do
      if( colormachine.data[ m_prefix ].grey_shades[ i ]==1 ) then
         local translated_color = colormachine.translate_color_name( nil, m_prefix, gname, -1, -1, i, 0 );
         if( translated_color ~= nil ) then
            form = form.."image_button["..tostring( #colormachine.colors+1 )..","..tostring( i+1 )..";1,1;"..translated_color..";"..gname.."; ]";
         end
      end
   end
   return form;
end



colormachine.decode_color_name = function( meta, new_color )

   -- decode the color codes
   local liste = new_color:split( "_" );
   if( #liste < 1 or #liste > 3 ) then
      liste = {'white'};
   end
   -- perhaps it's one of the grey colors?
   for i,v in ipairs( colormachine.grey_names ) do
      if( v == liste[1] ) then
         meta:set_string('selected_shade',      -1 ); -- grey-shade
         meta:set_string('selected_grey_shade',  i );
         meta:set_string('selected_color',      -1 ); -- we selected grey
         meta:set_string('selected_name',       new_color );
         return new_color;
      end
   end

   if( #liste < 1 ) then
      return meta:get_string('selected_name');
   end

   local selected_shade = 2; -- if no other shade is selected, use plain color
   local vgl = liste[1]..'_';
   for i,v in ipairs( colormachine.prefixes ) do
      if( v == vgl or v== liste[1]) then
         selected_shade = i;
         table.remove( liste, 1 ); -- this one has been done
      end
   end

   if( #liste < 1 ) then
      return meta:get_string('selected_name');
   end

   local selected_color = -1;
   for i,v in ipairs( colormachine.colors ) do
      if( v == liste[1] ) then
         selected_color = i;
         table.remove( liste, 1 ); -- the color has been selected
      end
   end
 
   -- the color was not found! error! keep the old color
   if( selected_color == -1 ) then
      return meta:get_string('selected_name');
   end

   if( #liste > 0 and liste[1]=='s50') then
      selected_shade = selected_shade * 2;
   else
      selected_shade = selected_shade * 2 - 1;
   end

   meta:set_string('selected_shade',      selected_shade ); -- grey-shade
   meta:set_string('selected_grey_shade', -1 );
   meta:set_string('selected_color',      selected_color ); -- we selected grey
   meta:set_string('selected_name',       new_color );
   return new_color;
end



-- returns the translated name of the color if necessary (wool/normal dye is named differently than unifieddyes);
-- either meta or c, s and g together need to be given
colormachine.translate_color_name = function( meta, k, new_color, c, s, g, as_obj_name )

   if( meta ~= nil ) then
      c = tonumber(meta:get_string('selected_color'));
      s = tonumber(meta:get_string('selected_shade'));   
      g = tonumber(meta:get_string('selected_grey_shade')); 
   end


   -- is this special shade supported at all?
   if(  ( g >   0 and colormachine.data[k].grey_shades[ g ] ~= 1 )
     or ( g == -1 and colormachine.data[k].shades[      s ] ~= 1 )) then
      return nil;
   end

   -- k is the prefix for the filename of the texture file; unifieddyes_ does not supply all colors
   local k_new = k;
   if( k == 'unifieddyes_' 
     and ( (g==-1 and s==3 and not(c==4 or c==6 or c==8 or c==12 or c==13 ))
        or g==1 or g==3 or g==5 )) then
      k_new = 'dye_';
   end

   -- beds and sofas are available in less colors
   if( g==-1 
     and (k=='beds_bed_top_top_' or k=='lrfurn_sofa_right_front_' or k=='lrfurn_armchair_front_' or k=='lrfurn_longsofa_middle_front_' )
     and (c==7 or c==11) ) then

      return nil;
   end

   -- blox has its own naming scheme - but at least the colors supported are of a simple kind (no shades, no lower saturation)
   if( colormachine.data[k].modname == 'blox' ) then

      local color_used = "";
      if( s==1 and c==1 ) then
         color_used = 'pink'; -- in blox, this is called "pink"; normally "light_red"
      elseif( g>-1 ) then 
         color_used = colormachine.grey_names[ g ];
      elseif( s ~= 3 ) then
         return nil; -- only normal saturation supported
      elseif( c==10 ) then
         color_used = 'purple'; -- purple and violet are not the same, but what shall we do?
      elseif( c==4 or c==6 or c==8 or c>10 ) then
         return nil; -- these colors are not supported
      elseif( c > 0 ) then
         color_used = colormachine.colors[ c ];
      end

      if( as_obj_name == 1 ) then
         return 'blox:'..( color_used )..( colormachine.data[k].add );
      else
         return 'blox_'..( color_used )..( colormachine.data[k].add )..'.png';
      end
   end
 

   local postfix = '.png';
   -- we want the object name, i.e. default:brick, and not default_brick.png (all with colors inserted...):
   if( as_obj_name == 1 ) then
      postfix = '';

      k_new = colormachine.data[ k ].modname..":"..colormachine.data[ k ].add;

      -- stained_glass needs an exception here because it uses a slightly different naming scheme
      if( colormachine.data[ k ].modname == 'stained_glass') then

         local h_trans = {yellow=1, lime=2, green=3, aqua=4, cyan=5, skyblue=6, blue=7, violet=8, magenta=9, redviolet=10, red=11,orange=12};
      
         local h = h_trans[ colormachine.colors[c] ];

         local b   = "";
         local sat = "";
 
         if( k == 'stained_glass_' ) then
            k_new = "stained_glass:"..(colormachine.colors[c]).."_";
            if(     s==1 or s==2) then b = "8"; -- light
            elseif( s==3 or s==4) then b = "5"; -- normal
            elseif( s==5 or s==6) then b = "4"; -- medium
            elseif( s==7 or s==8) then b = "3"; -- dark
            end
            k_new = k_new.."_";
 
            sat = "7";
            if( s==2 or s==4 or s==6 or s==8 ) then -- saturation
               sat = "6";
            end
            return "stained_glass:" .. (h) .. "_" .. (b) .. "_" .. (sat);

         elseif( k == 'stained_glass_faint_' ) then
            return "stained_glass:"..(h).."_91";

         elseif(     k == 'stained_glass_pastel_' ) then
            return "stained_glass:"..(h).."_9";
         end
      end
   end

   -- homedecors names are slightly different....
   if( k == 'homedecor_window_shutter_' ) then

      if( s==1 and new_color=='light_blue' ) then -- only light blue is supported
         return k_new..'light_blue'..postfix;
 
      elseif( new_color=='dark_green' ) then
         return k_new..'forest_green'..postfix;

      -- no more light colors, no more cyan or mangenta available; no normal green or blue
      elseif( s==1 or c==7 or c==11 or c==5 or c==9 ) then
         return nil;

      elseif( new_color=='dark_orange' ) then
         return k_new..'mahogany'..postfix;

      elseif( new_color=='orange' ) then
         return k_new..'oak'..postfix;
 
      end
   end


   -- normal dyes (also used for wool) use a diffrent naming scheme
   if( colormachine.data[k].u == 0 ) then
      if(     new_color == 'darkgrey' ) then
         return k_new..'dark_grey'..postfix;  
      elseif( new_color == 'dark_orange' ) then
         return k_new..'brown'..postfix;
      elseif( new_color == 'dark_green'  ) then
         return k_new..new_color..postfix;
      elseif( new_color == 'light_red'   ) then
         return k_new..'pink'..postfix;
      -- lime, aqua, skyblue and redviolet do not exist as standard wool/dye colors
      elseif( g == -1 and (c==4 or c==6 or c==8 or c==12)) then 
         return nil;
      -- all other colors of normal dye/wool exist only in normal shade
      elseif( g == -1 and s~= 3 ) then
         return nil;
      -- colors that are the same in both systems and need no special treatment
      else
         return k_new..new_color..postfix;
      end
   end

   return k_new..new_color..postfix;
end


-- if a block is inserted, the name of its color is very intresting (for removing color or for setting that color)
-- (kind of the inverse of translate_color_name)
colormachine.get_color_from_blockname = function( mod_name, block_name )

   local bname = mod_name..":"..block_name;

   local found = {};
   for k,v in pairs( colormachine.data ) do
      if( mod_name == v.modname ) then
         table.insert( found, k );
      end
   end 

   if( #found < 1 ) then
      return { error_code ="Sorry, this block is not supported by the spray booth.",
               found_name = "",
               blocktype  = ""};
   end
     
   -- another case of special treatment needed; at least the color is given in the tiles 
   if( mod_name =='stained_glass' ) then 

      local original_node = minetest.registered_nodes[ bname ];
      if( original_node ~= nil ) then
         local tile   = original_node.tiles[1];
         local liste2 = string.split( tile, "%.");
         block_name = liste2[1];
      end
   end


   -- blox uses its own naming scheme
   if( mod_name =='blox' ) then
      -- the color can be found in the description
      local original_node = minetest.registered_nodes[ bname ];
      if( original_node ~= nil ) then

         local bloxdescr = original_node.description;
         -- bloxparts[1] will be filled with the name of the color:
         local bloxparts = string.split( bloxdescr, " ");
         -- now extract the blocktype information         
         if( bloxparts ~= nil and #bloxparts > 0 ) then

            -- we split with the color name
            local found_name      = bloxparts[1];
            local blocktype       = 'blox_'..string.sub( block_name, string.len( found_name )+1 )..'_';
               
            -- handle pink and purple
            if(     found_name == 'pink' ) then
               found_name = 'light_red';
            elseif( found_name == 'purple' ) then
               found_name = 'violet';
            end

            return { error_code = nil,
                     found_name = found_name, -- the name of the color
                     blocktype  = blocktype }; -- the blocktype
         end
      end
      -- if this point is reached, the decoding of the blox-block-name has failed
      return { error_code = "Error: Failed to decode color of this blox-block.",
               found_name = "",
               blocktype  = "" }; 

   end

   -- homedecors names are slightly different....
   if( mod_name == 'homedecor' ) then

      -- change the blockname to the expected color
      if(     block_name == 'shutter_forest_green' ) then
         block_name = 'shutter_dark_green';

      elseif( block_name == 'shutter_mahogany' ) then
         block_name = 'shutter_dark_orange';
 
      -- this is the default, unpainted one..which can also be considered as "orange" in the menu
--      elseif( blockname == 'shutter_oak' ) then 
--         block_name = 'shutter_orange';
      end
   end


   -- try to analyze the name of this color; this works only if the block follows the color scheme
   local liste = string.split( block_name, "_" );
   local curr_index = #liste;

   -- handle some special wool- and dye color names
   -- dark_grey <-> darkgrey
   if(     #liste > 1 and liste[ curr_index ]=='grey' and liste[ curr_index - 1 ] == 'dark' ) then
      curr_index = curr_index - 1;
      liste[ curr_index ] = 'darkgrey';

   -- brown <=> dark_orange
   elseif( #liste > 0 and liste[ curr_index ]=='brown' ) then
      liste[ curr_index ] = 'dark';
      table.insert( liste, 'orange' );
      curr_index = curr_index + 1;
  
   -- pink <=> light_red
   elseif( #liste > 0 and liste[ curr_index ]=='pink' ) then
      liste[ curr_index ] = 'light';
      table.insert( liste, 'red' );
      curr_index = curr_index + 1;
   end
 
   -- find out the saturation - either "s50" or omitted
   local sat = 0;
   if( curr_index > 1 and liste[ curr_index ] == "s50" ) then
      sat = 1;
      curr_index = curr_index - 1;
   end

   -- the next value will be the color
   local c = 0;
   if( curr_index > 0 ) then
      for i,v in ipairs( colormachine.colors ) do
         if( c==0  and curr_index > 0 and v == liste[ curr_index ] ) then
            c = i;
            curr_index = curr_index - 1;
         end
      end
   end

   local g = -1;
   -- perhaps we are dealing with a grey value
   if( curr_index > 0 and c==0 ) then
      for i,v in ipairs(colormachine.grey_names ) do
         if( g==-1 and curr_index > 0 and v == liste[ curr_index ] ) then
            g = i;
            c = -1;
            curr_index = curr_index - 1;
         end
      end
   end

   -- determine the real shade; 3 stands for normal
   local s = 3;
   if( curr_index > 0 and g==-1 and c~=0) then
      if(     liste[ curr_index ] == 'light' ) then
        s = 1;
        curr_index = curr_index - 1;
      elseif( liste[ curr_index ] == 'medium' ) then
        s = 5;
        curr_index = curr_index - 1;
      elseif( liste[ curr_index ] == 'dark'   ) then
        s = 7;
        curr_index = curr_index - 1;
      end
   end

   local found_name = "";
   if(     g ~= -1 ) then
      found_name = colormachine.grey_names[ g ];
   elseif( c  >  0 ) then

      found_name = colormachine.prefixes[ math.floor((s+1)/2) ] .. colormachine.colors[ c ];

      if( sat==1 ) then
         s = s+1;
         found_name = found_name.."_s50";
      end
   end
   -- for blocks that do not follow the naming scheme - the color cannot be decoded
   if( g==-1 and c==0 ) then
      return { error_code ="This is a colored block: "..tostring( bname )..".", 
               found_name = "",
               blocktype  = ""};
   end

   -- identify the block type/subname
   local add       = "";
   local blocktype = found[1];

   if( curr_index > 0 ) then

      for k,v in pairs( colormachine.data ) do
         if( curr_index > 0 and add=="" and mod_name == v.modname and (liste[ curr_index ].."_") == v.add ) then
            add        = v.add;
            blocktype  = k;
            curr_index = curr_index - 1;
         end
      end 
   end

   if( curr_index > 0 ) then
      print( 'colormachine: ERROR: leftover name parts for '..tostring( bname )..": "..minetest.serialize( liste ));
   end

   return { error_code = nil,
            found_name = found_name,
            blocktype  = blocktype};
end



-- if the player has selected a color, show all blocks in that color
colormachine.blocktype_menu = function( meta, new_color )

   new_color = colormachine.decode_color_name( meta, new_color );

   -- keep the same size as with the color selector
   local form = "size["..tostring( #colormachine.colors+2 )..",10]".."label[5,0;Select a blocktype:]"..
                "label[0.2,1.2;name]"..
                "label[0.2,2.2;unpainted]"..
                "label[0.2,3.2;colored]"..
                "button[1,0.5;4,1;dye_management;Manage stored dyes]"..
                "button[5,0.5;4,1;main_menu;Back to main menu]";
   local x = 1;
   local y = 2;

   for i,k in ipairs( colormachine.ordered ) do

      -- only installed mods are of intrest
      if( k ~= nil and colormachine.data[ k ].installed == 1 ) then

         -- that particular mod may not offer this color
         form = form.."button["..tostring(x)..","..tostring(y-0.8)..  ";1,1;"..k..";"..colormachine.data[k].descr.."]"..
                  "item_image["..tostring(x)..","..tostring(y    )..";1,1;"..colormachine.data[k].block.."]"; 

         local translated_color = colormachine.translate_color_name( meta, k, new_color, nil, nil, nil, 1 );
         if( translated_color ~= nil ) then
            form = form..  "item_image["..tostring(x)..","..tostring(y+1)..";1,1;"..translated_color.."]"; 
         else
            form = form.."button["..      tostring(x)..","..tostring(y+1)..";1,1;"..k..";n/a]";
         end

         x = x+1;
         if( x>13 ) then
            x = 1;
            y = y+3;
            form = form..
                "label[0.2,"..tostring(y-1)..".2;name]"..
                "label[0.2,"..tostring(y  )..".2;unpainted]"..
                "label[0.2,"..tostring(y+1)..".2;colored]";
         end
      end
   end
   return form;
end



-- this function tries to figure out which block type was inserted and how the color can be decoded
colormachine.main_menu_formspec = function( pos, option )

   local i = 0;
   local k = 0;
   local v = 0;

   local form = "size[11,9]"..
                "list[current_player;main;1,5;8,4;]"..
                "label[3,0.2;Spray booth main menu]"..
                "button[1,1;4,1;dye_management;Manage stored dyes]"..
                "button[5,1;4,1;blocktype_menu;Show supported blocks]"..

                "label[1,2.5;input:]"..
                "list[current_name;input;1,3.0;1,1;]";

   local meta = minetest.env:get_meta(pos);
   local inv  = meta:get_inventory();

   -- display the name of the color the machine is set to
   form = form.."label[2.2,4.3;Current painging color:]"..
                "label[5.0,4.3;"..(meta:get_string('selected_name') or "?" ).."]"..
   -- display the owner name
                "label[6,0.2;(owner: "..(meta:get_string('owner') or "?" )..")]";

   if( inv:is_empty( "input" )) then
      form = form.."label[2.2,3.0;Insert block to be analyzed.]";
      return form;
   end

   local stack = inv:get_stack( "input", 1);
   local bname = stack:get_name();
   -- lets find out if this block is one of the unpainted basic blocks calling for paint
   local found = {};
   for k,v in pairs( colormachine.data ) do
      if( bname == v.block ) then
         table.insert( found, k );
      end
   end 

   -- make sure all output fields are empty
   for i = 1, inv:get_size( "output" ) do
      inv:set_stack( "output", i, "" );
   end

   local anz_blocks = stack:get_count();

   -- a block that can be colored
   if( #found > 0 ) then
    
      local anz_found  = 0;
      for i,v in ipairs( found ) do
         if( i <= inv:get_size( "output" )) then

            -- offer the description-link
            form = form.."button["..tostring(2+i)..","..tostring(1.8)..";1,1;"..v..";"..colormachine.data[v].descr.."]";

            local translated_color = colormachine.translate_color_name( meta, v, meta:get_string('selected_name'), nil, nil, nil, 1 );
            --print( 'BLOCK type to use: '..tostring(v).."  translated_color: "..tostring(translated_color)..".");
            if( translated_color ~= nil ) then
               inv:set_stack( "output", i, translated_color.." "..tostring( anz_blocks ));


               -- this time, we want the texture
               translated_color = colormachine.translate_color_name( meta, v, meta:get_string( 'selected_name'), nil, nil, nil, 0 );
               if( translated_color ~= nil ) then
                  --form = form..  "item_image["..tostring(x)..","..tostring(y+1)..";1,1;"..translated_color.."]"; 
                  form = form.."image_button["..tostring(2+i)..","..tostring(2.5)..";1,1;"..
                                          translated_color..";"..v.."; ]"; -- when clicking here, the color selection menu for that blocktype is presented
               end
            else
               inv:set_stack( "output", i, "" );

--               form = form.."button["      ..tostring(2+i)..","..tostring(2.5)..";1,1;"..v..";"..colormachine.data[v].descr.."]";
               form = form.."button["..      tostring(2+i)..","..tostring(2.5)..";1,1;"..v..";n/a]";
            end
            anz_found = anz_found + 1;


         end
      end
      
      -- this color was not supported
      if( anz_found == 0 ) then
         form = form.."label[2.2,3.0;Sorry, this block is not available in that color.]";
         return form;
      end
      
      form = form.."label[3,1.5;Available variants:]"..
                   "list[current_name;output;3,3.5;"..tostring( anz_found )..",1;]";
      return form;
   end -- end of handling of blocks that can be colored


   -- get the modname
   local parts = string.split(bname,":");
   if( #parts < 2 ) then
      form = form.."label[2.2,3.0;ERROR! Failed to analyze the name of this node: "..tostring(bname).."]";
      return form;
   end
      

   -- it may be a dye source
   for i,v in ipairs( colormachine.basic_dye_sources ) do
      -- we have found the right color!
      if( bname == v ) then
         form = form.."label[2.2,3.0;This is a dye source.]";
         return form;
      end
   end


   -- it is possible that we are dealing with an already painted block - in that case we have to dertermie the color
   local found_color_data = colormachine.get_color_from_blockname( parts[1], parts[2] );
   if( found_color_data.error_code ~= nil ) then
      form = form.."label[2.2,3.0;"..found_color_data.error_code..".]";
      return form;
   end

   -- the previous analyse was necessary in order to determine which block we ought to use
   if( option == 'remove_paint' ) then
      -- actually remove the paint from the 
      inv:set_stack( "input", 1, colormachine.data[ found_color_data.blocktype ].block.." "..tostring( anz_blocks ));
      -- update display (we changed the input!)
      return colormachine.main_menu_formspec(pos, "analyze");
   end


   if( option == 'adapt_color' ) then
      -- actually change the color
      colormachine.decode_color_name( meta, found_color_data.found_name );
      -- default color changed - update the menu
      return colormachine.main_menu_formspec(pos, "analyze");
   end

   -- print color name; select as input color / remove paint
   form = form.."label[2.2,3.0;This is: "..tostring( found_color_data.found_name )..".]"..
                "button[6,3.5;3,1;remove_paint;Remove paint]";

   if( found_name ~= meta:get_string( 'selected_name' )) then
      form = form.."button[6,2.6;3,1;adapt_color;Set as new color]";
   else
      form = form.."label[5.5,2.0;This is the selected color.]";
   end
 
   return form;
end




colormachine.check_owner = function( pos, player )
   -- only the owner can put something in
   local meta = minetest.env:get_meta(pos);

   if( meta:get_string('owner') ~= player:get_player_name() ) then
      minetest.chat_send_player( player:get_player_name(),
                 "This spray booth belongs to "..tostring( meta:get_string("owner"))..
                 ". If you want to use one, build your own!");
      return 0;
   end
   return 1;
end


colormachine.allow_inventory_access = function(pos, listname, index, stack, player, mode)

   -- only specific slots accept input or output
   if(  (mode=="put"  and listname ~= "input" and listname ~= "refill" and listname ~= "dyes" )
     or (mode=="take" and listname ~= "input" and listname ~= "refill" and listname ~= "dyes" and listname ~= "output" and listname ~= "paintless" )) then
      return 0;
   end

   -- the dyes are a bit special - they accept only powder of the correct name
   if( listname == "dyes" 
       and ( index < 1 
          or index > #colormachine.basic_dye_names 
          or not( stack:get_name())
          or stack:get_name() ~= ("dye:"..colormachine.basic_dye_names[ index ]))) then

      minetest.chat_send_player( player:get_player_name(), 'You can only store dye powders of the correct color here.');
      return 0;
   end

   if( not( colormachine.check_owner( pos, player ))) then
      return 0;
   end

   -- let's check if that type of input is allowed here
   if( listname == "refill" ) then
      local str = stack:get_name();
      for i,v in ipairs( colormachine.basic_dye_sources ) do
         if( str == v ) then
            return stack:get_count();
         end
      end
      minetest.chat_send_player( player:get_player_name(), 'Please insert dye sources as listed below here (usually plants)!');
      return 0;
   end

   return stack:get_count();
end


colormachine.on_metadata_inventory_put = function( pos, listname, index, stack, player )
  
   local meta = minetest.env:get_meta(pos);
   local inv  = meta:get_inventory();

   -- nothing to do if onnly a dye was inserted
   if( listname == "dyes" ) then
      return;
   end

   -- an unprocessed color pigment was inserted
   if( listname == "refill" ) then
      local str = stack:get_name();
      for i,v in ipairs( colormachine.basic_dye_sources ) do
         -- we have found the right color!
         if( str == v ) then
            local count = stack:get_count();

            -- how much free space do we have in the destination stack?
            local dye_stack = inv:get_stack( "dyes", i);
            local free      = math.floor(dye_stack:get_free_space()/4);
            if( free < 1 ) then
               minetest.chat_send_player( player:get_player_name(), 'Sorry, the storage for that dye is already full.');
               return 0;
            end
            if( count < free ) then
               free = count;
            end

            -- consume the inserted material - no more than the input slot can handle
            inv:remove_item(listname, stack:get_name().." "..tostring( free ));
            -- add four times that much to the storage
            inv:set_stack( "dyes", i, ("dye:"..colormachine.basic_dye_names[i] ).." "..tostring( free*4 + dye_stack:get_count()) );
            return;
         end
      end
      minetest.chat_send_player( player:get_player_name(), 'Please insert dye sources as listed below here (usually plants)!');
      return 0;
   end

   if( listname == "input" ) then
      -- update the main menu accordingly
      meta:set_string( 'formspec', colormachine.main_menu_formspec( pos, "analyze" ));
      return;
   end
end


colormachine.on_metadata_inventory_take = function( pos, listname, index, stack, player )
  
   local meta = minetest.env:get_meta(pos);
   local inv  = meta:get_inventory();


   if( listname == "output" ) then

      -- TODO: consume color for painted blocks

      -- calculate how much was taken
      local anz_taken   = stack:get_count();
      local anz_present = inv:get_stack("input",1):get_count();
      anz_present = anz_present - anz_taken;
      if( anz_present <= 0 ) then
         inv:set_stack( "input", 1, "" ); -- everything used up
      else
         inv:set_stack( "input", 1, inv:get_stack("input",1):get_name().." "..tostring( anz_present ));
      end
        
      -- the main menu needs to be updated as well
      meta:set_string( 'formspec', colormachine.main_menu_formspec( pos, "analyze" ));
      return;
   end


   if( listname == "input" ) then
      -- update the main menu accordingly
      meta:set_string( 'formspec', colormachine.main_menu_formspec( pos, "analyze" ));
      return;
   end
end


colormachine.init = function()
   local liste = {};
   -- create formspecs for all machines
   for k,v in pairs( colormachine.data ) do

      if( minetest.get_modpath( colormachine.data[ k ].modname ) ~= nil ) then

         -- generate the formspec for that machine
         colormachine.data[ k ].formspec = colormachine.generate_form( k );
         -- remember that the mod is installed
         colormachine.data[ k ].installed = 1;
         -- this is helpful for getting an ordered list later
--         liste[ colormachine.data[ k ].nr ] = k;
         table.insert( liste, k );
      else
         -- the mod is not installed
         colormachine.data[ k ].installed = 0;
      end
   end

   table.sort( liste, function(a,b) return colormachine.data[a].nr < colormachine.data[b].nr end); 
   colormachine.ordered = liste;

   -- if no flowers are present, take dye sources from default (so we only have to depend on dyes)
   if( minetest.get_modpath( "flowers") == nil ) then
      colormachine.basic_dye_sources  = colormachine.alternate_basic_dye_sources;
   end

   local form = "size[10,9]"..
                "list[current_player;main;1,5;8,4;]"..
                "label[2,0.2;Insert dye sources here -->]"..
                "list[current_name;refill;8,0;1,1;]"..
                "label[0.1,1;sources:]"..
                "label[0.1,2;dyes:]"..
                "label[0.1,3;storage:]"..
                "button[1,4;4,1;main_menu;Back to main menu]"..
                "button[5,4;4,1;blocktype_menu;Show supported blocks]"..
                "list[current_name;dyes;1,3;"..tostring(#colormachine.basic_dye_sources)..",1;]";

   for i,k in ipairs( colormachine.basic_dye_sources ) do
   
      form = form.."item_image["..tostring(i)..",1;1,1;"..k.."]"..
                   "item_image["..tostring(i)..",2;1,1;dye:"..tostring( colormachine.basic_dye_names[ i ] ).."]";
   end
   colormachine.dye_management_formspec = form;

end



-- delay initialization so that modules are hopefully loaded
minetest.after( 2, colormachine.init );


--    flowers:       6 basic colors + black + white
--  unifieddyes:   dye pulver
--  coloredwood:   wood, fence - skip sticks!
--  unifiedbricks: clay blocks, brick blocks (skip individual clay lumps and bricks!)
--                 multicolor: 3 shades, usual amount of colors
--  cotton:        (by jordach) probably the same as coloredwood
--   
--  stained_glass: 9 shades/intensities


minetest.register_node("colormachine:colormachine", {
        description = "spray booth",

        tiles = {"default_chest.png"},

        paramtype2 = "facedir",
        groups = {cracky=2},
        legacy_facedir_simple = true,

        on_construct = function(pos)

           local meta = minetest.env:get_meta(pos);

           meta:set_string('selected_shade',       3 ); -- grey-shade
           meta:set_string('selected_grey_shade',  1 );
           meta:set_string('selected_color',      -1 ); -- we selected grey
           meta:set_string('selected_name',       'white' );

           meta:set_string('owner', '' ); -- protect input from getting stolen

           local inv = meta:get_inventory();
           inv:set_size("input",     1);  -- input slot for blocks that are to be painted
           inv:set_size("refill",    1);  -- input slot for plants and other sources of dye pigments
           inv:set_size("output",    8);  -- output slot for painted blocks - up to 8 alternate coloring schems supported (blox has 8 for stone!)
           inv:set_size("paintless", 1);  -- output slot for blocks with paint scratched off
           inv:set_size("dyes",      8);  -- internal storage for the dye powders

           --meta:set_string( 'formspec', colormachine.blocktype_menu( meta, 'white' ));
           meta:set_string( 'formspec', colormachine.main_menu_formspec(pos, "analyze") );
        end,

        after_place_node = function(pos, placer)
           local meta = minetest.env:get_meta(pos);

           meta:set_string( "owner", ( placer:get_player_name() or "" ));
           meta:set_string( "infotext", "Spray booth (owned by "..( meta:get_string( "owner" ) or "" )..")");
        end,

        on_receive_fields = function(pos, formname, fields, sender)

           if( not( colormachine.check_owner( pos, sender ))) then
              return 0;
           end

           local meta = minetest.env:get_meta(pos);
           for k,v in pairs( fields ) do
              if( k == 'main_menu' ) then
                 meta:set_string( 'formspec', colormachine.main_menu_formspec(pos, "analyze") );
                 return;
              elseif( k == 'remove_paint' ) then
                 meta:set_string( 'formspec', colormachine.main_menu_formspec(pos, "remove_paint") );
                 return;
              elseif( k == 'adapt_color' ) then
                 meta:set_string( 'formspec', colormachine.main_menu_formspec(pos, "adapt_color") );
                 return;
              elseif( k == 'dye_management' ) then
                 meta:set_string( 'formspec', colormachine.dye_management_formspec );
                 return;
              elseif( colormachine.data[ k ] ) then
                 meta:set_string( 'formspec', colormachine.data[ k ].formspec );
                 return;
              elseif( k=='key_escape') then
                 -- nothing to do
              else
                 local inv = meta:get_inventory();
            
                 -- if no input is present, show the block selection menu
                 if( k=="blocktype_menu" or inv:is_empty( "input" )) then
                    meta:set_string( 'formspec', colormachine.blocktype_menu( meta, k )); 

                 -- else set the selected color and go back to the main menu
                 else
                    colormachine.decode_color_name( meta, k );
                    meta:set_string( 'formspec', colormachine.main_menu_formspec(pos, "analyze") );
                 end
              end
           end
        end,

        -- there is no point in moving inventory around
        allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
           return 0;
        end,

        
        allow_metadata_inventory_put = function(pos, listname, index, stack, player)
           return colormachine.allow_inventory_access(pos, listname, index, stack, player, "put" );
        end,


        allow_metadata_inventory_take = function(pos, listname, index, stack, player)
           return colormachine.allow_inventory_access(pos, listname, index, stack, player, "take" );
        end,

        on_metadata_inventory_put = function(pos, listname, index, stack, player)
           return colormachine.on_metadata_inventory_put( pos, listname, index, stack, player );
        end,

        on_metadata_inventory_take = function(pos, listname, index, stack, player)
           return colormachine.on_metadata_inventory_take( pos, listname, index, stack, player );
        end,

        can_dig = function(pos,player)

           local meta = minetest.env:get_meta(pos);
           local inv = meta:get_inventory()

           if( not( colormachine.check_owner( pos, player ))) then
              return 0;
           end

           if(   not( inv:is_empty("input"))
              or not( inv:is_empty("refill")))  then
              minetest.chat_send_player( player:get_player_name(), "Please remove the material in the input- and/or refill slot first!"); 
              meta:set_string( 'formspec', colormachine.blocktype_menu( meta, meta:get_string('selected_name'))); 
              return false;
           end
           if(  not( inv:is_empty("dyes"))) then
              minetest.chat_send_player( player:get_player_name(), "Please remove the stored dyes first!"); 
              meta:set_string( 'formspec', colormachine.blocktype_menu( meta, meta:get_string('selected_name') )); 
              return false;
           end

           return true
        end
})
