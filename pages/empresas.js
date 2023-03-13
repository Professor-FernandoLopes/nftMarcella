
import { Hero,HeroEmpresas } from "@components/ui/common"
import { CourseList, CourseCard,CourseEmpresa } from "@components/ui/course"
import { BaseLayout } from "@components/ui/layout"
import { getAllCourses } from "@content/courses/empresas.js"
import Head from 'next/head'
export default function Home({courses}) {
  return (
    <>
<Head>
<meta property="og:image" content="/guia.png" />
</Head>
      <HeroEmpresas />
      <CourseList
        courses={courses}
      >
      {course =>
        <CourseEmpresa
          key={course.id}
          course={course}
        />
      }
      </CourseList>
    </>
  )
}

export function getStaticProps() {
  const { data } = getAllCourses()
  return {
    props: {
      courses: data
    }
  }
}

Home.Layout = BaseLayout
