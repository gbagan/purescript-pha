exports.pointerPositionAux = nothing => just => e => () => {
    const rect = e.currentTarget.getBoundingClientRect();
    if (!rect) return nothing;
    return e.clientX >= rect.left && e.clientX < rect.left + rect.width && e.clientY >= rect.top && e.clientY < rect.top + rect.height ?
    just ({
        x: (e.clientX - rect.left) / rect.width,
        y: (e.clientY - rect.top) / rect.height
    }) : nothing;
};