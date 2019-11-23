module Pha.Svg where
import Prelude
import Pha (VDom, Prop, h, text)
import Pha.Html (class EUnit, attr)

g :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
g = h "g"
    
svg :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
svg = h "svg"
    
rect :: ∀a effs u1 u2 u3 u4. EUnit u1 => EUnit u2 => EUnit u3 => EUnit u4 => u1 -> u2 -> u3 -> u4 -> Array (Prop a effs) -> VDom a effs
rect x' y' w h' props = h "rect" ([attr "x" x', attr "y" y', attr "width" w, attr "height" h'] <> props) []
    
path :: ∀a effs. String -> Array (Prop a effs) -> VDom a effs
path d props = h "path" ([attr "d" d] <> props) []
    
line ::  ∀a effs u1 u2 u3 u4. EUnit u1 => EUnit u2 => EUnit u3 => EUnit u4 =>
            u1 -> u2 -> u3 -> u4 -> Array (Prop a effs) -> VDom a effs
line x1 y1 x2 y2 props = h "line" ([attr "x1" x1, attr "y1" y1, attr "x2" x2, attr "y2" y2] <> props) []
    
circle :: ∀a effs u1 u2 u3. EUnit u1 => EUnit u2 => EUnit u3 =>
            u1 -> u2 -> u3 -> Array (Prop a effs) -> VDom a effs
circle cx cy r props = h "circle" ([attr "cx" cx, attr "cy" cy, attr "r" r] <> props) []
    
use :: ∀a effs u1 u2 u3 u4. EUnit u1 => EUnit u2 => EUnit u3 => EUnit u4 =>
                u1 -> u2 -> u3 -> u4 -> String -> Array (Prop a effs) -> VDom a effs
use x' y' w h' href' props =
    h "use" ([attr "x" x', attr "y" y', attr "width" w, attr "height" h', attr "href" href'] <> props) []
    
text' :: ∀a effs u. EUnit u => u -> u -> String -> Array (Prop a effs) -> VDom a effs
text' x' y' t props = h "text" ([attr "x" x', attr "y" y'] <> props) [text t]

-- svg
x :: ∀a effs u. EUnit u => u -> Prop a effs
x = attr "x"
y :: ∀a effs u. EUnit u => u -> Prop a effs
y = attr "y" 
width :: ∀a effs u. EUnit u => u -> Prop a effs
width = attr "width"
height :: ∀a effs u. EUnit u => u -> Prop a effs
height = attr "height"
stroke :: ∀a effs. String -> Prop a effs
stroke = attr "stroke"
opacity :: ∀a effs. String -> Prop a effs
opacity = attr "opacity"
fill :: ∀a effs. String -> Prop a effs
fill = attr "fill"
viewBox :: ∀a effs. Int -> Int -> Int -> Int -> Prop a effs
viewBox x1 x2 x3 x4 = attr "viewBox" $ show x1 <> " " <> show x2 <> " " <> show x3 <> " " <> show x4
transform :: ∀a effs. String -> Prop a effs
transform = attr "transform"
strokeWidth :: ∀a effs. String -> Prop a effs
strokeWidth = attr "stroke-width"
strokeDasharray :: ∀a effs. String -> Prop a effs
strokeDasharray = attr "stroke-dasharray"
    
svguse :: ∀a effs. String -> Array (Prop a effs) -> VDom a effs
svguse symbol props = svg ([width "100%", height "100%"]  <> props) [h "use" [attr "href" symbol] []]
