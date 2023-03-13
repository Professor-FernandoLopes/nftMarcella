
import Image from "next/image"

export default function Hero({
title,
description,
image,
hasOwner
}) {


return (
<section>
<div className="relative bg-amber overflow-hidden">
<div className="max-w-7xl mx-auto">
<div className="relative z-10 pb-8 bg-amber sm:pb-16 md:pb-20 lg:max-w-2xl lg:w-full lg:pb-28 xl:pb-32">
<svg className="hidden lg:block absolute right-0 inset-y-0 h-full w-48 text-blue2 transform translate-x-1/2" fill="currentColor" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">
<polygon points="50,0 100,0 50,100 0,100" />
</svg>
<div className="relative pt-6 px-4 sm:px-6 lg:px-8">
</div>
<main className="mt-10 mx-auto max-w-7xl px-4 sm:mt-12 sm:px-6 md:mt-16 lg:mt-20 lg:px-8 xl:mt-28">
<div className="sm:text-center lg:text-left">
{ hasOwner &&
<div className="text-xl inline-block p-4 py-2 rounded-full font-bold text-blue2 bg-green-200 text-green-700">
You are owner of:
</div>
}
<h1 className="text-4xl tracking-tight font-extrabold text-blue2 sm:text-5xl md:text-6xl">
<span className="block xl:inline">
{title.substring(0, title.length / 2)}
</span>
<span className="block text-blue2 xl:inline">
{title.substring(title.length / 2)}
</span>
</h1>
<p className="mt-3 text-base text-blue2 sm:mt-5 sm:text-lg sm:max-w-xl sm:mx-auto md:mt-5 md:text-xl lg:mx-0">
{description}
</p>
<div className="mt-5 sm:mt-8 sm:flex sm:justify-center lg:justify-start">

<div className="rounded-md shadow bg-blue2">

<a href="https://ipfs.io/ipfs/Qme2FxGnrkJLMSyEEqnYVtWtjK3LaLXtg6jqFmry7EK7gy">
Leia o NFT CONTRACT.
</a>

</div>
{ /*
<div className="mt-3 sm:mt-0 sm:ml-3">
<a href="#" className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-indigo-700 bg-indigo-100 hover:bg-indigo-200 md:py-4 md:text-lg md:px-10">
Watch
</a>
</div>
*/ }
</div>
</div>
</main>
</div>
</div>
<div className="lg:absolute lg:inset-y-0 lg:right-0 lg:w-1/2">
<Image
className="h-56 w-full object-cover sm:h-72 md:h-96 lg:w-full lg:h-full"
src={image}
alt={title}
layout="fill"
/>
</div>
</div>
</section>
)
}
