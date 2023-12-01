import React, { useState } from "react";

const ButtonGreen = ({ text, func }) => {
    return (
        <button className="bg-grin font-montserrat font-bold text-lg text-white py-2 
            px-5 rounded-lg mb-4 hover:bg-darkgrin active:bg-grin" onClick={!func ? null : func}>
        {text}
        </button>
    );
};

const ButtonPink = ({ text, func }) => {
    return (
        <button className="bg-pinkk font-montserrat font-bold text-lg text-white py-2 
            px-5 rounded-lg mb-4 hover:bg-darkpinkk active:bg-pinkk" onClick={!func ? null : func}>
        {text}
        </button>
    );
    };

export { ButtonGreen, ButtonPink };