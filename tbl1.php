
<html>
<h3>HPSS User Quota Usage:</h3>

<table style="border:1px solid black;" cellspacing="2px;">
<?php

// open the file
if (($handle = fopen("result1.txt", "r")) !== false) {

    // TODO: use fgets() to find the row..


    // loop through each row
    while (($data = fgetcsv($handle, 0, "|")) !== false) {

        echo "<tr>";
        $num = count($data);
        for ($c = 0; $c < $num; $c++)
        {
            echo "<td style=\"border:1px solid black;\">" . $data[$c] . "</td>";
        }

        echo "</tr>";

    }

    // close file
    fclose($handle);
}
?>
</table>
</html>
