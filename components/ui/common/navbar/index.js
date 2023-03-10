

import { useWeb3 } from "@components/providers"
import Link from "next/link"
import { ActiveLink, Button } from "@components/ui/common"
import { useAccount } from "@components/hooks/web3"
import { useRouter } from "next/router"

export default function Navbar() {
const { connect, isLoading, requireInstall } = useWeb3()
const { account } = useAccount()
const { pathname } = useRouter()

return (
<section className=" container mx-auto  " >
<div className="relative  pt-6 px-4 sm:px-6 lg:px-8">

<div className="mx-auto max-w-7xl px-2 sm:px-6 lg:px-8">
<div className="relative flex h-16 items-center justify-between">

<div>
<ActiveLink href="/" >
<a
className="font-medium mr-8 text-blue2 hover:text-blue2">
Home
</a>
</ActiveLink>
<ActiveLink href="/marketplace" >
<a
className="font-medium mr-8 text-blue2 hover:text-gray-900">
Comprar 
</a>
</ActiveLink>
<ActiveLink href="/blogs" >
{  <a
className="font-medium mr-8 text-gray-500 hover:text-gray-900">
{/*  Blogs */ }
</a> }
</ActiveLink>
</div>
<div className="text-center">
<ActiveLink href="/wishlist" >
<a
className="font-medium sm:mr-8 mr-1 text-purple-500 hover:text-gray-900">
{/*  Wishlist */ }
</a>
</ActiveLink>
{ isLoading ?
<Button
disabled={true}
onClick={connect}>
Loading...
</Button> :

account.data ?
<Button onClick={(e) => { e.preventDefault();
window.location.href=`https://polygonscan.com/address/${account.data}`;
      }}
 className="font-medium sm:mr-8 mr-1 text-white-500 hover:text-white-100"> 
{account.data.slice(0, 5) + '...' + account.data.slice(38, 42)}
</Button>
:
requireInstall ?

<Button
onClick={() => window.open("https://metamask.io/download.html", "_blank")}>
Instale Metamask
</Button> :

<Button
onClick={connect}>
Connect
</Button>
}
</div>
</div>
</div>

</div>
{ account.data &&
!pathname.includes("/marketplace") &&
<div className="flex justify-end pt-1 sm:px-6 lg:px-8">
<div className="text-gray-500 hover:text-gray-900 rounded-md p-2">

</div>
</div>
}
</section>
)
}
