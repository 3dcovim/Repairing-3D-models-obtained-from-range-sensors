% Example code to demonstrate Fields of Experts.
%   
% Author:  Stefan Roth, Department of Computer Science, Brown University
% Contact: roth@cs.brown.edu
% $Date: 2005-06-09 12:08:55 -0400 (Thu, 09 Jun 2005) $
% $Revision: 72 $
% 
% Demo functions:
%   demo_denoise_foe        - Demonstrate FoE with image denoising
%   demo_inpaint_foe        - Demonstrate FoE with image inpainting
%
% Image reconstruction tools:
%   denoise_foe             - Denoise an image
%   inpaint_foe             - Inpaint an image
%   psnr                    - Compute peak signal to noise ratio
%
% FoE implementation:
%   evaluate_foe_log        - Compute log density of FoE for an image
%   evaluate_foe_log_grad   - Compute gradient (w.r.t image) of log 
%                             density for an image
%

% Copyright 2004,2005, Brown University, Providence, RI.
% 
%                         All Rights Reserved
% 
% Permission to use, copy, modify, and distribute this software and its
% documentation for any purpose other than its incorporation into a
% commercial product is hereby granted without fee, provided that the
% above copyright notice appear in all copies and that both that
% copyright notice and this permission notice appear in supporting
% documentation, and that the name of Brown University not be used in
% advertising or publicity pertaining to distribution of the software
% without specific, written prior permission.
% 
% BROWN UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
% INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY
% PARTICULAR PURPOSE.  IN NO EVENT SHALL BROWN UNIVERSITY BE LIABLE FOR
% ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
