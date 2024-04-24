import React from 'react';

import makeStyles from '@mui/styles/makeStyles';

import company_logo from './images/logo.svg';

const useStyles = makeStyles((theme) => ({
	Logo: {
		height: 27,
		color: 'white',
		fontSize: 20,
		fontWeight: 'bold',
		textDecoration: 'none',
	},
}));

export default function Logo(props) {
	const classes = useStyles();

	let link = 'https://streamingpro.es';

	// eslint-disable-next-line no-useless-escape
	return (
		<a href={link} className={classes.Logo} target="_blank" rel="noopener noreferrer">
			Streaming pro
		</a>
	);
}
