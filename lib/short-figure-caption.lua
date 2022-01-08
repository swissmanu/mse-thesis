--
-- Credit for this filter goes to:
--   https://gist.github.com/davejm/508e7f46b88041497a66c9493b4b4a89
--
-- Thank you! <3
--

-- don't do anything unless we target latex
if FORMAT ~= "latex" then
  return {}
end

local List = require'pandoc.List'

local function latex(str)
  return List:new{pandoc.RawInline('latex', str)}
end

local function is_figure(para)
  return #para.content == 1 and para.content[1].t == "Image"
end

local function is_titled(para)
  return para.content[1].title ~= "fig:" -- just 'fig:' means there's no title
end

local function read_inlines(txt)
  return pandoc.read(txt).blocks[1].content
end

local function make_caption(long_caption, short_caption)
  return latex'\\caption['
    .. short_caption .. latex']{'
    .. long_caption .. latex'}\n'
end

local function img_has_long_caption(img)
  return #img.caption ~= 0
end

local function first_sentence(str)
  local first_sentence_index = str:find('.', 0, true)
  if not first_sentence_index then
    return nil
  end
  return str:sub(0, first_sentence_index)
end

local function figure_with_short_caption(para)
  if not is_figure(para) then
    return nil
  end

  local img = para.content[1]

  if not img_has_long_caption(img) then
    return nil
  end

  local short_caption

  if is_titled(para) then
    -- Use the alt attribute for the short caption
    short_caption = read_inlines(img.title:gsub('^fig:', ''))
  else
    -- Falling back to using the first sentence of the long caption

    -- Note that converting the pandoc object to text using stringify removes
    -- all formatting but this shouldn't be a big problem for short captions.
    local short_caption_str = first_sentence(pandoc.utils.stringify(img.caption))

    if not short_caption_str then
      -- Couldn't get the first sentence so falling back to regular caption
      short_caption = img.caption
    end

    -- Convert the string back into a Pandoc object
    short_caption = read_inlines(short_caption_str)
  end

  return pandoc.Plain(
    latex'\\begin{figure}\n\\centering\n'
      .. {img}
      .. latex'\n'
      .. make_caption(img.caption, short_caption)
      .. latex'\\end{figure}'
  )
end

return {{Para = figure_with_short_caption}}
