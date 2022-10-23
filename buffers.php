<?php
                
                $multiplier = 180;
                $size = 1024 * $multiplier;
                $permitted_chars = '0123456789abcdefghijklmnopqrstuvwxyz';
                $size -= 1;

                for($i = 1; $i <= $size; $i++) {
                        // echo ".";
                        echo substr(str_shuffle($permitted_chars), 0, 1);
                }

                sleep(5);
                echo "<br/>Hello World";
        ?>
