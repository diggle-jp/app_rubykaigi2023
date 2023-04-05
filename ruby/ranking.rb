require 'js'

$rank = [
  ['[DIGGLE] zakky', 34.798],
  ['[DIGGLE] umeda', 32.952],
  ['[DIGGLE] t_ito', 16.933],
  ['[DIGGLE] niku', 21.345],
  ['[DIGGLE] taisei', 16.119],
  ['[DIGGLE] tushar', 52.651],
  ['[DIGGLE] kato', 23.464],
  ['xxxx', 111],
  ['xxxx', 112],
  ['xxxx', 113],
  ['xxxx', 114],
  ['xxxx', 115],
  ['xxxx', 116],
  ['xxxx', 117],
  ['xxxx', 118],
  ['xxxx', 119],
  ['xxxx', 120],
  ['xxxx', 121],
  ['xxxx', 122],
  ['xxxx', 123],
  ['xxxx', 124],
  ['xxxx', 125],
  ['xxxx', 126],
  ['xxxx', 128],
  ['xxxx', 129],
].sort{|a, b| a.last <=> b.last}.freeze
# $JS_NULL = JS.eval("return null")
$document = JS.global[:document]

$prev_btn = $document.getElementById('prev')
$next_btn = $document.getElementById('next')

class Ranking
  attr_reader :page

  def initialize
    @page = 0
  end

  def create_header
    create_tr('th', 'No.', 'name', 'time(ms)')
  end

  def create_tr(child_node, no, name, time)
    tr = $document.createElement('tr')
    [no, name, time].each do |label|
      td = $document.createElement(child_node)
      td[:innerHTML] = label.to_s
      tr.appendChild(td)
    end
    tr
  end

  def render(offset)
    @page += offset
    table = $document.getElementById('ranking')
    until (target = table[:firstChild]) == JS::Null do
      table.removeChild(target)
    end

    table.appendChild(create_header)

    s_idx = page * 10
    $rank.slice(s_idx, 10).each.with_index do |rank, idx|
      table.appendChild(create_tr('td', s_idx + idx + 1, *rank))
    end

    $prev_btn[:disabled] = false
    $next_btn[:disabled] = false
    $prev_btn[:disabled] = true if page.zero?
    $next_btn[:disabled] = true if (page + 1) * 10 > $rank.size
  end
end

$ranking = Ranking.new
$ranking.render(0)
$prev_btn.addEventListener('click', ->(e) { $ranking.render(-1) }, false)
$next_btn.addEventListener('click', ->(e) { $ranking.render(1) }, false)