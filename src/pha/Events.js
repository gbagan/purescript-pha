exports.setPointerCaptureE = ev => () => ev && ev.target && ev.pointerId != null &&
                        ev.target.releasePointerCapture && ev.target.releasePointerCapture(ev.pointerId);
exports.releasePointerCaptureE = ev => () => ev && ev.target && ev.pointerId != null &&
                        ev.target.releasePointerCapture && ev.target.releasePointerCapture(ev.pointerId);