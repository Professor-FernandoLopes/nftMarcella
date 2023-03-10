

import Link from "next/link"

export default function Footer() {

  return (
    <footer className="bg-blue2 pt-1">
      <div className="container mx-auto px-6">
        <div className="mt-5 flex flex-col items-center">
          <div className="py-6">
            <p className="mb-6 text-white text-sm text-primary-2 font-bold">
            © {new Date().getFullYear()} <></>
             
             <Link  href="https://datacurrency.uk ">
            
              DataCurrency
              
                
                </Link>
            </p>
          </div>
        </div>
      </div>
    </footer>
  )
}
