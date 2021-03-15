<?php
/**
 * Output the phpinfo for our setup
 */
?>
<nav class="center">
	<a href="/phpinfo/">PHP Info</a>
	<?php
	if ( function_exists( 'xdebug_info' ) ) {
		?>, <a href="/xdebuginfo/">Xdebug Info</a><?php
	}
	?>
</nav>
<hr/>
<?php
echo '<div id="phpinfo">';
phpinfo();
echo '</div>';
