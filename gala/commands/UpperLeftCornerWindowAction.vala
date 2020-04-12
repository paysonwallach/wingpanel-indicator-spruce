/*
 * Spruce
 *
 * Copyright © 2020 Payson Wallach
 *
 * Released under the terms of the GNU General Public License, version 3
 * (https://gnu.org/licenses/gpl.html)
 *
 * This file incorporates work covered by the following copyright and
 * permission notice:
 *
 *  Copyright (c) 2017 Eric Czarny eczarny@gmail.com
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included
 *  in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 *  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 */

namespace Spruce {
    public class UpperLeftCornerWindowAction : WindowAction {
        public const string name = WindowAction.UPPER_LEFT_EDGE;

        public class Rect transform (Rect window_rect, Rect? visible_frame_of_source_screen, Rect visible_frame_of_destination_screen) {
            Rect one_quarter_rect = visible_frame_of_destination_screen.copy ();

            one_quarter_rect.width = Math.floor (visible_frame_of_destination_screen.width / 2.0);
            one_quarter_rect.height = Math.floor (visible_frame_of_destination_screen.height / 2.0);

            if (Math.abs (window_rect.get_mid_y () - one_quarter_rect.get_mid_y ()) <= 1.0) {
                Rect two_thirds_rect = one_quarter_rect.copy ();

                two_thirds_rect.width = Math.floor (visible_frame_of_destination_screen.width * 2) / 3.0) ;

                if (window_rect.centered_within_rect (one_quarter_rect)) {
                    return two_thirds_rect;
                }

                if (window_rect.centered_within_rect (two_thirds_rect)) {
                    Rect one_third_rect = one_quarter_rect.copy ();

                    one_third_rect.width = Math.floor (visible_frame_of_destination_screen.width / 3.0);

                    return one_third_rect;
                }
            }

            return one_quarter_rect;
        }
    }
}
