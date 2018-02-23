;; ---------------------------------------------------------------
;; batch-cartoon: A script to batch process photos into cartons.
;; Copyright (C) 2018 Jason J.A. Stephenson <jason@sigio.com>
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;; ---------------------------------------------------------------

;; This script is intended to batch process a series of photos into
;; cartoon-like images.  It applies the Gaussian blur filter followed
;; by the Cartoon artistic filter using the options provided as
;; arguments.  It replaces the original images with the results of
;; applying the filter, so be sure to work on copies if you want to
;; keep the original images intact.
;;
;; Arguments:
;; pattern: A file glob pattern to match files to open, i.e '*.jpg', '*.png', etc.
;; gaussHorizRadius: A float value for the horizontal radius argument to the Gaussian blur filter
;; gaussVertRadius: A float value for the vertical radius argument to the Gaussian blur filter
;; gaussMode: A literal 0 or 1 for the IIR or RLE Gaussian blur modes, respectively
;; maskRadius: A float value for the mask radius argument to the cartoon filter plug-in
;; blackPercent: A float value between 0.0 and 1.0 for the black percentage argument to the cartoon filter

(define (batch-cartoon pattern gaussHorizRadius gaussVertRadius gaussMethod maskRadius blackPercent)
  (let* ((filelist (cadr (file-glob pattern 1))))
    (while (not (null? filelist))
           (let* ((filename (car filelist))
                  (image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
                  (drawable (car (gimp-image-get-active-layer image))))
             (plug-in-gauss RUN-NONINTERACTIVE image drawable gaussHorizRadius gaussVertRadius gaussMethod)
             (plug-in-cartoon RUN-NONINTERACTIVE image drawable maskRadius blackPercent)
             (gimp-file-save RUN-NONINTERACTIVE image drawable filename filename)
             (gimp-image-delete image))
           (set! filelist (cdr filelist)))))