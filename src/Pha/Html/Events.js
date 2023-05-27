export const valueImpl = (el, nothing, just) =>
    typeof el.value === "string" ? just(el.value) : nothing